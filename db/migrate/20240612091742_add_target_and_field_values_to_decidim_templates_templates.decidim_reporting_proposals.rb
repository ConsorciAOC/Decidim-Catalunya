# frozen_string_literal: true
# This migration comes from decidim_reporting_proposals (originally 20230404103706)

class AddTargetAndFieldValuesToDecidimTemplatesTemplates < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_templates_templates, :field_values, :json, default: {} unless ActiveRecord::Base.connection.column_exists?(:decidim_templates_templates, :field_values)
    add_column :decidim_templates_templates, :target, :string unless ActiveRecord::Base.connection.column_exists?(:decidim_templates_templates, :target)
  end
end
