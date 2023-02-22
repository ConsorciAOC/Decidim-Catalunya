# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?

  mount Decidim::Core::Engine => "/"
  mount Decidim::FileAuthorizationHandler::AdminEngine => "/admin"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
