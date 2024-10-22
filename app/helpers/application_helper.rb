# frozen_string_literal: true

require "decidim/sanitize_helper"

module ApplicationHelper
  include Decidim::SanitizeHelper

  def google_tag_manager_code
    Rails.application.secrets.google_tag_manager_code
  end

  def google_tag_manager_data_layer(organization)
    layer = <<-EOLAYER
    { "CODIENS" : "#{organization.via_oberta_settings&.fetch("ine") || ""}",
      "nomEns" : "#{organization.google_tag_manager_settings&.fetch("entity_name") || ""}",
      "nomTenant" : "#{organization.name}" }
    EOLAYER
    layer.html_safe
  end
end
