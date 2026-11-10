# frozen_string_literal: true

Rails.application.config.to_prepare do
  Rails.application.config.i18n.raise_on_missing_translations = false if Rails.env.production? || Rails.env.staging?
end
