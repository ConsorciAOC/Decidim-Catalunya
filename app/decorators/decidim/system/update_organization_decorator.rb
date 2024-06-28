# frozen_string_literal: true

module Decidim
  module System
    class UpdateOrganizationDecorator
      def self.decorate!
        Decidim::System::UpdateOrganization.class_eval do
          private

          alias_method :original_save_organization, :save_organization

          def save_organization
            # Customization for google_tag_manager
            organization.google_tag_manager_settings = form.google_tag_manager_settings

            original_save_organization
          end
        end
      end
    end
  end
end

Decidim::System::UpdateOrganizationDecorator.decorate!
