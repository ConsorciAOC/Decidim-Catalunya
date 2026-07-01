# frozen_string_literal: true

HealthCheck.setup do |config|
  # Drop the SMTP check so the container probe does not fail when no mail server is reachable
  config.standard_checks -= ["emailconf"]
end
