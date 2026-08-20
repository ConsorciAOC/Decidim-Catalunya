# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20210413050756)
# This file has been modified by `decidim upgrade:migrations` task on 2026-06-26 11:58:37 UTC
class AddPublishedAtToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_meetings, :published_at, :datetime, index: true
  end
end
