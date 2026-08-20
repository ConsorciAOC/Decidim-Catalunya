# frozen_string_literal: true

# This migration comes from decidim_conferences (originally 20210408204953)
# This file has been modified by `decidim upgrade:migrations` task on 2026-06-26 11:58:36 UTC
class AllowNullLogoColumnInDecidimConferencesPartnersTable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :decidim_conferences_partners, :logo, true
  end
end
