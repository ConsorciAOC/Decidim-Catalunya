# frozen_string_literal: true

Decidim::System::UpdateOrganizationForm.class_eval do
  jsonb_attribute :via_oberta_settings, [
    [:nif, String],
    [:ine, String],
    [:municipal_code, String],
    [:province_code, String]
  ]
end
