# frozen_string_literal: true

require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module ViaObertaAuthorization
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ViaObertaAuthorization

      initializer "decidim_via_oberta_authorization.add_authorization_handlers" do |_app|
        Decidim::Verifications.register_workflow(
          :via_oberta_authorization_handler
        ) do |auth|
          auth.form = "ViaObertaAuthorizationHandler"
        end
      end
    end
  end
end
