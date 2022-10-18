class AddViaObertaConfigToDecidimOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_organizations, :via_oberta_settings, :jsonb
  end
end
