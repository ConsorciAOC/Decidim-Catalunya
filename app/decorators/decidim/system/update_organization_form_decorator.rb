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
            if form.google_tag_manager_settings &&
               organization.respond_to?(:trusted_ids_census_config) &&
               organization.trusted_ids_census_config
              form.google_tag_manager_settings["entity_code"] =
                organization.trusted_ids_census_config.settings&.fetch("ine", nil)
            end
            form
          end
        end
      end
    end
  end
end

Decidim::System::UpdateOrganizationFormDecorator.decorate!
