# frozen_string_literal: true

module Decidim
  module System
    module GoogleTagManagerUpdateOrganizationOverride
      extend ActiveSupport::Concern

      included do
        private

        alias_method :gtm_original_save_organization, :save_organization

        def save_organization
          organization.google_tag_manager_settings = form.google_tag_manager_settings
          gtm_original_save_organization
        end
      end
    end
  end
end
