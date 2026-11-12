# frozen_string_literal: true

require "json"

module HeroContentBlockSettings
  VERSION = 1

  def self.export(path)
    records = Decidim::ContentBlock.where(manifest_name: "hero").order(:id)
                                   .pluck(:id, :decidim_organization_id, :scope_name, :settings)
                                   .map do |id, organization_id, scope_name, settings|
      { id: id, organization_id: organization_id, scope_name: scope_name, settings: settings }
    end

    File.open(path, "wx", 0o600) do |file|
      file.write(JSON.pretty_generate(version: VERSION, content_blocks: records))
      file.write("\n")
    end
    records.size
  end

  def self.restore(path)
    backup = JSON.parse(File.read(path))
    records = validate_backup!(backup)

    Decidim::ContentBlock.transaction do
      records.each do |record|
        block = Decidim::ContentBlock.lock.find_by!(
          id: record.fetch("id"),
          decidim_organization_id: record.fetch("organization_id"),
          scope_name: record.fetch("scope_name"),
          manifest_name: "hero"
        )
        current = block[:settings]
        raise ArgumentError, "Invalid current settings for hero block #{block.id}" unless current.nil? || current.is_a?(Hash)

        saved = record.fetch("settings")
        restored = (saved || {}).merge(current || {})
        next if restored == (current || {})

        block.update_columns(settings: restored, updated_at: Time.current)
      end
    end
    records.size
  end

  def self.validate_backup!(backup) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    raise ArgumentError, "Invalid hero settings backup format or version" unless backup.is_a?(Hash) && backup["version"] == VERSION && backup["content_blocks"].is_a?(Array)

    records = backup.fetch("content_blocks")
    ids = []
    records.each do |record|
      valid = record.is_a?(Hash) &&
              record["id"].is_a?(Integer) && record["id"].positive? &&
              record["organization_id"].is_a?(Integer) && record["organization_id"].positive? &&
              record["scope_name"].is_a?(String) && !record["scope_name"].empty? &&
              record.key?("settings") && (record["settings"].nil? || record["settings"].is_a?(Hash))
      raise ArgumentError, "Invalid hero settings backup record" unless valid

      ids << record.fetch("id")
    end
    raise ArgumentError, "Duplicate hero content block IDs in backup" unless ids.uniq.size == ids.size

    records
  end
  private_class_method :validate_backup!
end
