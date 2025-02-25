# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { github: "CodiTramuntana/decidim", branch: "release/0.28-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

# gem "decidim-decidim_awesome", "~> 0.11.0"
gem "decidim-file_authorization_handler", github: "CodiTramuntana/decidim-file_authorization_handler", branch: "master"
# Simplified & mobile-first proposals creation (ie: fixmystreets behavior)
# gem "decidim-reporting_proposals", github: "CodiTramuntana/decidim-module-reporting-proposals", branch: "fix/error_with_form_builder_override"
# VALiD & ViaOberta integration
gem "decidim-trusted_ids", github: "ConsorciAOC-PRJ/decidim-module-trusted-ids", branch: "upgrade/release-0.28"

gem "decidim-cdtb"

gem "concurrent-ruby", "1.3.4"

gem "base64", "0.1.1"
gem "net-smtp"
gem "stringio", "3.0.1"
gem "strscan", "3.0.1"

gem "bootsnap", "~> 1.3"
gem "wicked_pdf", "~> 2.7.0"
gem "wkhtmltopdf-binary"

# Blob storage in the cloud

gem "azure-storage-blob"

gem "deface"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  # Set versions because Property AutoCorrect errors.
  gem "rspec-rails", "~> 6.0.4"
  gem "rubocop-factory_bot", "2.25.1"
  gem "rubocop-rspec", "2.26.1"
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

  # LoadError - cannot load such file -- rexml/document
  gem "rexml"
end

group :test do
  gem "database_cleaner"
end
