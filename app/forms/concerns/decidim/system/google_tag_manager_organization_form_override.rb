# frozen_string_literal: true

module Decidim
  module System
    # Customization for GoogleTagManager
    module GoogleTagManagerOrganizationFormOverride
      extend ActiveSupport::Concern

      included do
        jsonb_attribute :google_tag_manager_settings, [
          [:entity_code, String],
          [:entity_name, String]
        ]

        alias_method :gtm_original_map_model, :map_model

        def map_model(model)
          gtm_original_map_model(model)
          return unless google_tag_manager_settings
          return unless model.respond_to?(:trusted_ids_census_config) && model.trusted_ids_census_config

          google_tag_manager_settings["entity_code"] = model.trusted_ids_census_config.settings&.fetch("ine", nil)
        end
      end
    end
  end
end
