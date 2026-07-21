# frozen_string_literal: true

require_relative "boot"

require "decidim/rails"

# Figjam normally loads config/application.yml into ENV via a `before_configuration`
# hook, which only fires once `Rails::Application` is defined below. Bundler.require
# runs before that point, so gems that read ENV at require time (e.g.
# decidim-trusted_ids' `config_accessor` blocks, which capture their value once and
# cache it) would otherwise see ENV before application.yml has been loaded into it.
# Load it here, first, so ENV is populated before any gem is required.
require "figjam"
Figjam::Application.new(
  path: File.expand_path("application.yml", __dir__),
  environment: ENV.fetch("RAILS_ENV", nil) || "development"
).load

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
    config.load_defaults 6.1

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Make decorators available
    config.to_prepare do
      Rails.root.glob("app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
