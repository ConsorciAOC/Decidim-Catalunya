# frozen_string_literal: true

module Decidim
  module System
    class CreateOrganizationDecorator
      def self.decorate!
        Decidim::System::CreateOrganization.class_eval do
          alias_method :original_create_organization, :create_organization

          def create_organization
            organization = original_create_organization
            # Customization for GoogleTagManager
            if form.respond_to?(:google_tag_manager_settings)
              organization.update!(google_tag_manager_settings: form.google_tag_manager_settings)
            end
            organization
          end
        end
      end
    end
  end
end

Decidim::System::CreateOrganizationDecorator.decorate!
