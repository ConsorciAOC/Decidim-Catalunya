# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = Decidim::Env.new("DECIDIM_APPLICATION_NAME", "My Application Name").to_s
  config.mailer_sender = Decidim::Env.new("DECIDIM_MAILER_SENDER", "change-me@example.org").to_s

  config.available_locales = Decidim::Env.new("DECIDIM_AVAILABLE_LOCALES", "ca,cs,de,en,es,eu,fi,fr,it,ja,nl,pl,pt,ro").to_array
  config.default_locale = Decidim::Env.new("DECIDIM_DEFAULT_LOCALE", "en").to_s.to_sym

  # HERE maps
  config.maps = {
    provider: :here,
    api_key: Decidim::Env.new("GEOCODER_LOOKUP_API_KEY").to_s,
    static: { url: "https://image.maps.hereapi.com/mia/v3/base/mc/overlay" }
  }
  config.geocoder = {
    timeout: 5,
    units: :km
  }

  config.content_security_policies_extra = {
    "connect-src" => %w(self *.hereapi.com *.jsdelivr.net data: https://*.blob.core.windows.net https://region1.google-analytics.com),
    "img-src" => %w(self *.hereapi.com https://*.blob.core.windows.net blob:),
    "frame-src" => %w(https://*.blob.core.windows.net),
    "script-src" => %w(https://www.googletagmanager.com),
    "style-src" => %w(self unsafe-inline https://fonts.googleapis.com),
    "font-src" => %w(self https://fonts.gstatic.com)
  }

  config.enable_html_header_snippets = Decidim::Env.new("DECIDIM_ENABLE_HTML_HEADER_SNIPPETS").present?

  track_newsletter_links = Decidim::Env.new("DECIDIM_TRACK_NEWSLETTER_LINKS", "auto")
  config.track_newsletter_links = track_newsletter_links.present? unless track_newsletter_links.to_s == "auto"

  config.enable_machine_translations = false

  config.throttling_max_requests = Decidim::Env.new("DECIDIM_THROTTLING_MAX_REQUESTS", "100").to_i
  config.throttling_period = Decidim::Env.new("DECIDIM_THROTTLING_PERIOD", "1").to_i.minutes

  config.follow_http_x_forwarded_host = Decidim::Env.new("DECIDIM_FOLLOW_HTTP_X_FORWARDED_HOST").present?
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)

Decidim::Initiatives.default_components = []
