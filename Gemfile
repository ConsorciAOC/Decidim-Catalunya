# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim.git", branch: "release/0.25-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-file_authorization_handler", git: "https://github.com/CodiTramuntana/decidim-file_authorization_handler.git", tag: "v0.25.2.4"
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-decidim_awesome", "~> 0.8"
gem "decidim-via_oberta_authorization", path: "decidim-via_oberta_authorization"

gem "decidim-idcat_mobil", "~> 0.3.0"
# Although `omniauth-rails_csrf_protection` is already a Decidim dependency, it is not working unless declared here.
# In meta.decidim.org, which is at Decidim v0.26, this declaration is not required. Try to remove it after upgrading to Decidim v0.26
gem "omniauth-rails_csrf_protection"

gem "bootsnap", "~> 1.3"
gem "wicked_pdf", "~> 2.1"

# Blob storage in the cloud
gem "azure-storage-blob", require: false

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
