# frozen_string_literal: true

module ApplicationHelper
  include Decidim::SanitizeHelper

  def google_tag_manager_code
    Decidim::Env.new("GOOGLE_TAG_MANAGER_CODE").to_s
  end

  def google_tag_manager_data_layer(organization)
    census_code = organization.trusted_ids_census_config&.settings&.fetch("ine") if organization.respond_to?(:trusted_ids_census_config)
    layer = <<-EOLAYER
    { "CODIENS" : "#{census_code || ""}",
      "nomEns" : "#{organization.google_tag_manager_settings&.fetch("entity_name") || ""}",
      "nomTenant" : "#{translated_attribute(organization.name)}" }
    EOLAYER
    layer.html_safe
  end
end
