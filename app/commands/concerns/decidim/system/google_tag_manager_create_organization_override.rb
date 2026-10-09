# frozen_string_literal: true

module Decidim
  module System
    module GoogleTagManagerCreateOrganizationOverride
      extend ActiveSupport::Concern

      included do
        private

        alias_method :gtm_original_create_organization, :create_organization

        def create_organization
          organization = gtm_original_create_organization
          organization.update!(google_tag_manager_settings: form.google_tag_manager_settings) if form.respond_to?(:google_tag_manager_settings)
          organization
        end
      end
    end
  end
end
