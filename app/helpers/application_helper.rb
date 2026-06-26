# frozen_string_literal: true

require "decidim/sanitize_helper"

module ApplicationHelper
  include Decidim::SanitizeHelper

  def google_tag_manager_code
    Rails.application.secrets.google_tag_manager_code
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
