# frozen_string_literal: true

require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module ViaObertaAuthorization
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ViaObertaAuthorization

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      initializer "decidim_via_oberta_authorization.add_authorization_handlers" do |_app|
        Decidim::Verifications.register_workflow(
          :via_oberta_authorization_handler
        ) do |auth|
          auth.form = "ViaObertaAuthorizationHandler"
        end
      end

      config.to_prepare do
        decorators = "#{Decidim::ViaObertaAuthorization::Engine.root}/app/decorators"
        Rails.autoloaders.main.ignore(decorators)
        Dir.glob("#{decorators}/**/*_decorator.rb").each do |decorator|
          load decorator
        end
      end
    end
  end
end
