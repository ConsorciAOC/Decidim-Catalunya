# frozen_string_literal: true

Rails.application.config.to_prepare do
  # This is due to the bug in https://github.com/decidim/decidim/issues/15949 that affects other models (like an authorization)
  # To remove when the issue is fixed upstream.
  Decidim::Notification.include(NotificationFixer)
end
