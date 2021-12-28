# frozen_string_literal: true

OmniAuth.config.full_host = Rails.application.secrets.omniauth[:idcat_mobil][:full_host]
OmniAuth.config.request_validation_phase = nil
OmniAuth.config.allowed_request_methods = [:post, :get]
