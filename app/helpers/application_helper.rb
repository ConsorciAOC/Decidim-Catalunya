# frozen_string_literal: true

module ApplicationHelper
  def google_tag_manager_code
    case Rails.env
    when "production" then "GTM-M4GV4QQ"
    else
      "GTM-PXH4TF2"
    end
  end

  def google_tag_manager_data_layer(organization)
    layer = <<-EOLAYER
    { "CODIENS" : "#{decidim_html_escape(organization.via_oberta_settings&.fetch("ine") || "")}",
      "nomEns" : "#{decidim_html_escape(organization.google_tag_manager_settings&.fetch("entity_name") || "")}",
      "nomTenant" : "#{decidim_html_escape(organization.name)}" }
    EOLAYER
    layer.html_safe
  end
end
