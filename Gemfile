# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { github: "CodiTramuntana/decidim", branch: "release/0.27-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-file_authorization_handler", github: "CodiTramuntana/decidim-file_authorization_handler", tag: "v0.27.1.7"
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "main"
# Simplified & mobile-first proposals creation (ie: fixmystreets behavior)
# gem "decidim-reporting_proposals", "~> 0.5.0"
gem "decidim-reporting_proposals", github: "openpoke/decidim-module-reporting-proposals", branch: "release/0.27-stable"
# VALiD & ViaOberta integration
gem "decidim-trusted_ids", github: "ConsorciAOC-PRJ/decidim-module-trusted-ids", branch: "main"

gem "decidim-cdtb", "~> 0.4.2"

gem "base64", "0.1.0"
gem "net-smtp", "~> 0.4.0"
gem "strscan", "3.0.0"

gem "bootsnap", "~> 1.3"
gem "wicked_pdf", "~> 2.7.0"

# Blob storage in the cloud

gem "azure-storage-blob"

gem "deface"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
end

group :development do
  gem "listen", "~> 3.1"
  gem "puma", ">= 5.0.0"
  gem "rubocop-rails"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.0"
end

group :development, :staging do
  gem "letter_opener_web", "~> 1.3"
end

group :production, :staging do
  gem "daemons"
  gem "delayed_job_active_record"
end

group :test do
  gem "database_cleaner"
  gem "rspec-rails"
end
