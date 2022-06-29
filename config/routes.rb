Rails.application.routes.draw do
  if Rails.env.development? || Rails.env.staging?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  mount Decidim::Core::Engine => '/'
  mount Decidim::FileAuthorizationHandler::AdminEngine => '/admin'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
