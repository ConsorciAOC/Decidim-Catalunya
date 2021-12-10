# frozen_string_literal: true

Decidim.configure do |config|
  # The name of the application
  config.application_name = "Decidim Catalunya"

  # The email that will be used as sender in all emails from Decidim
  config.mailer_sender = "change-me@example.org"

  # Sets the list of available locales for the whole application.
  #
  # When an organization is created through the System area, system admins will
  # be able to choose the available languages for that organization. That list
  # of languages will be equal or a subset of the list in this file.
  config.available_locales = [:ca, :es]

  # Sets the default locale for new organizations. When creating a new
  # organization from the System area, system admins will be able to overwrite
  # this value for that specific organization.
  config.default_locale = :ca

  # Whether SSL should be enabled or not.
  config.force_ssl = true

  # Map and Geocoder configuration
  config.maps = {
    provider: :here,
    api_key: Rails.application.secrets.maps[:api_key],
    static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
  }

  config.enable_html_header_snippets = false


  # Machine Translation Configuration
  #
  # Enable machine translations
  config.enable_machine_translations = false

end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
