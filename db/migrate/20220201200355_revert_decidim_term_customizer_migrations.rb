# frozen_string_literal: true

class RevertDecidimTermCustomizerMigrations < ActiveRecord::Migration[6.0]
  def change
    drop_table :decidim_term_customizer_constraints do |t|
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: 'decidim_term_customizer_constraint_organization' }
      t.references :subject, polymorphic: true, index: { name: 'decidim_term_customizer_constraint_subject' }

      t.references(
        :translation_set,
        null: false,
        foreign_key: { to_table: :decidim_term_customizer_translation_sets },
        index: { name: 'decidim_term_customizer_constraint_translation_set' }
      )
    end

    drop_table :decidim_term_customizer_translations do |t|
      t.string :locale
      t.string :key
      t.text :value

      t.references(
        :translation_set,
        null: false,
        foreign_key: { to_table: :decidim_term_customizer_translation_sets },
        index: { name: 'decidim_term_customizer_translation_translation_set' }
      )
    end

    drop_table :decidim_term_customizer_translation_sets do |t|
      t.jsonb :name
    end
  end
end
