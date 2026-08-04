# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.31-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome"
gem "decidim-file_authorization_handler", github: "CodiTramuntana/decidim-file_authorization_handler"
# Simplified & mobile-first proposals creation (ie: fixmystreets behavior)
gem "decidim-reporting_proposals", github: "openpoke/decidim-module-reporting-proposals", branch: "upgrade-0.31"
# VALiD & ViaOberta integration
gem "decidim-trusted_ids", github: "ConsorciAOC-PRJ/decidim-module-trusted-ids"

gem "decidim-cdtb", "~> 0.5.6"

gem "net-smtp"

gem "bootsnap", "~> 1.3"

# Blob storage in the cloud
gem "azure-blob"

gem "deface"

gem "delayed_job", "~> 4.1"
gem "delayed_job_active_record", "~> 4.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "web-console", "~> 4.0"
end

group :development, :staging do
  gem "letter_opener_web", "~> 1.3"
end

group :production, :staging do
  gem "daemons"
  gem "figjam"

  # LoadError - cannot load such file -- rexml/document
  gem "rexml"
end

group :test do
  gem "database_cleaner"
end
