# frozen_string_literal: true

# This migration comes from decidim (originally 20200211173227)

class AddDirectMessageTypesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :direct_message_types, :string, default: 'all'
    Decidim::UserBaseEntity.update_all(direct_message_types: 'all')
    change_column_null :decidim_users, :direct_message_types, false
  end
end
