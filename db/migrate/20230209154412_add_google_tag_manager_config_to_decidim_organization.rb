class AddGoogleTagManagerConfigToDecidimOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_organizations, :google_tag_manager_settings, :jsonb
  end
end
