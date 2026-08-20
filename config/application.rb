# frozen_string_literal: true

require_relative "boot"

require "decidim/rails"

# Add the frameworks used by your app that are not loaded by Decidim.
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimCatalunya
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]
    # we force to ignore the app/overrides folder, since we load it manually in the config.to_prepare block below
    # This is needed to avoid a crash when running DelayJob (does not affect Puma or Sidekiq)
    # because the autoloader tries to load the overrides folder and fails because it is not a valid Ruby module.
    Rails.autoloaders.main.ignore(Rails.root.join("app/overrides"))

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.to_prepare do
      Rails.root.glob("app/overrides/**/*.rb").each do |override|
        load override
      end

      # Customization for GoogleTagManager
      Decidim::System::RegisterOrganizationForm.include(Decidim::System::GoogleTagManagerOrganizationFormOverride)
      Decidim::System::UpdateOrganizationForm.include(Decidim::System::GoogleTagManagerOrganizationFormOverride)
      Decidim::System::CreateOrganization.include(Decidim::System::GoogleTagManagerCreateOrganizationOverride)
      Decidim::System::UpdateOrganization.include(Decidim::System::GoogleTagManagerUpdateOrganizationOverride)
    end
  end
end
