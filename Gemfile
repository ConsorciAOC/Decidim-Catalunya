# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.30-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "release/0.30-stable"
gem "decidim-file_authorization_handler", github: "CodiTramuntana/decidim-file_authorization_handler", tag: "v0.30.1.2"
# Simplified & mobile-first proposals creation (ie: fixmystreets behavior)
# TODO(upgrade): no 0.30 release exists (jumps 0.29 → 0.31) — restore at 0.31 (openpoke "upgrade-0.31"). Geolocated proposals disabled meanwhile.
# gem "decidim-reporting_proposals", github: "openpoke/decidim-module-reporting-proposals", branch: "upgrade-29.4"
# VALiD & ViaOberta integration
# TODO(upgrade): no 0.29 release exists — restore at 0.31 (ConsorciAOC-PRJ "upgrade-0.31"). Catalan e-ID VÀLid/Via Oberta disabled meanwhile.
# gem "decidim-trusted_ids", github: "ConsorciAOC-PRJ/decidim-module-trusted-ids", branch: "main"

gem "decidim-cdtb", "~> 0.5.6"

gem "net-smtp"

gem "bootsnap", "~> 1.3"

# Blob storage in the cloud
gem "azure-storage-blob"

gem "deface"

gem "delayed_job", "~> 4.1"
gem "delayed_job_active_record", "~> 4.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  gem "rspec-rails", "~> 6.0.4"
  # Versions driven by decidim-dev (0.29 requires rubocop-rspec ~> 3.0).
  gem "rubocop-factory_bot"
  gem "rubocop-rspec"
end

group :development do
  gem "listen", "~> 3.1"
  gem "puma", ">= 5.0.0"
  gem "rubocop-rails"
  gem "web-console", "~> 4.0"
end

group :development, :staging do
  gem "letter_opener_web", "~> 1.3"
end

group :production, :staging do
  gem "daemons"

  # LoadError - cannot load such file -- rexml/document
  gem "rexml"
end

group :test do
  gem "database_cleaner"
end
