# frozen_string_literal: true

require_relative "../hero_content_block_settings"

namespace :hero_content_block_settings do
  desc "Export all hero content block settings to a new JSON file"
  task :export, [:path] => :environment do |_task, args|
    raise ArgumentError, "Provide a JSON file path" if args.path.blank?

    count = HeroContentBlockSettings.export(args.path)
    puts "Exported settings for #{count} hero content blocks to #{args.path}"
  end

  desc "Restore missing hero content block settings from a JSON backup"
  task :restore, [:path] => :environment do |_task, args|
    raise ArgumentError, "Provide a JSON file path" if args.path.blank?

    count = HeroContentBlockSettings.restore(args.path)
    puts "Processed #{count} hero content blocks from #{args.path}"
  end
end
