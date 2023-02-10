# frozen_string_literal: true

module Decidim
  module System
    class UpdateOrganizationFormDecorator
      def self.decorate!
        Decidim::System::UpdateOrganizationForm.class_eval do
          jsonb_attribute :google_tag_manager_settings, [
            [:entity_code, String],
            [:entity_name, String]
          ]

          def self.from_model(organization)
            form = super
            form.google_tag_manager_settings["entity_code"] = organization.via_oberta_settings["ine"] if form.google_tag_manager_settings
            form
          end
        end
      end
    end
  end
end

Decidim::System::UpdateOrganizationFormDecorator.decorate!
