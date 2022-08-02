# frozen_string_literal: true

Decidim::System::UpdateOrganizationForm.class_eval do
  jsonb_attribute :via_oberta_settings, [
    [:ine, String],
    [:municipal_code, String],
    [:province_code, String]
  ]
end
