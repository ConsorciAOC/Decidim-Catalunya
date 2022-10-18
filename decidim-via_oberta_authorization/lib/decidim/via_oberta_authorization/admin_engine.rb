# frozen_string_literal: true

module Decidim
  module ViaObertaAuthorization
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::ViaObertaAuthorization::Admin
    end
  end
end
