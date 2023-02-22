# frozen_string_literal: true

module Decidim
  module System
    class RegisterOrganizationDecorator
      def self.decorate!
        Decidim::System::RegisterOrganization.class_eval do
          private

          def create_organization
            Decidim::Organization.create!(organization_decidim_catalunya_attrs)
          end

          def organization_decidim_catalunya_attrs
            {
              name: form.name,
              host: form.host,
              secondary_hosts: form.clean_secondary_hosts,
              reference_prefix: form.reference_prefix,
              available_locales: form.available_locales,
              available_authorizations: form.clean_available_authorizations,
              external_domain_whitelist: ["decidim.org", "github.com"],
              users_registration_mode: form.users_registration_mode,
              force_users_to_authenticate_before_access_organization: form.force_users_to_authenticate_before_access_organization,
              badges_enabled: true,
              user_groups_enabled: true,
              default_locale: form.default_locale,
              omniauth_settings: form.encrypted_omniauth_settings,
              smtp_settings: form.encrypted_smtp_settings,
              send_welcome_notification: true,
              file_upload_settings: form.file_upload_settings.final,
              # Customization for GoogleTagManager
              google_tag_manager_settings: form.google_tag_manager_settings
            }.merge(organization_decidim_catalunya_extended_attrs)
          end

          def organization_decidim_catalunya_extended_attrs
            {}
          end
        end
      end
    end
  end
end

Decidim::System::RegisterOrganizationDecorator.decorate!
