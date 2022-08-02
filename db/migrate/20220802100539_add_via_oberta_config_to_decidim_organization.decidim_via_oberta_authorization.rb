# This migration comes from decidim_via_oberta_authorization (originally 20220727064313)
class AddViaObertaConfigToDecidimOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_organizations, :via_oberta_settings, :jsonb
  end
end
