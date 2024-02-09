# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/via_oberta_authorization/version"
VIA_OBERTA_DECIDIM_VERSION = ">= #{Decidim::ViaObertaAuthorization::VERSION}"

Gem::Specification.new do |s|
  s.version = Decidim::ViaObertaAuthorization::VERSION
  s.authors = ["Laura Jaime"]
  s.email = ["laura.jv@coditramuntana.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/ConsorciAOC/Decidim-Catalunya"
  s.required_ruby_version = ">= 2.7.5"

  s.name = "decidim-via_oberta_authorization"
  s.summary = "AuthorizationHandler provider against Via Oberta"
  s.description = s.summary

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "Rakefile", "README.md"]

  s.add_dependency "decidim", VIA_OBERTA_DECIDIM_VERSION
  s.add_dependency "savon", "~> 2.11.2"
  s.add_dependency "virtus-multiparams", "~> 0.1.1"

  s.add_development_dependency "decidim-dev", VIA_OBERTA_DECIDIM_VERSION
  s.add_development_dependency "faker"
end
