# frozen_string_literal: true

# This migration comes from decidim_initiatives (originally 20170928160912)
# This file has been modified by `decidim upgrade:migrations` task on 2026-06-26 11:58:37 UTC
class RemoveScopeFromDecidimInitiativesVotes < ActiveRecord::Migration[5.1]
  def change
    remove_column :decidim_initiatives_votes, :scope, :integer
  end
end
