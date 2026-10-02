class RemoveOldBulletingBoardTables < ActiveRecord::Migration[7.2]
  def change
    drop_table :decidim_elections_actions, if_exists: true
    drop_table :decidim_elections_answers, if_exists: true
    drop_table :decidim_elections_bulletin_board_closures, if_exists: true
    drop_table :decidim_elections_elections, if_exists: true
    drop_table :decidim_elections_elections_trustees, if_exists: true
    drop_table :decidim_elections_questions, if_exists: true
    drop_table :decidim_elections_results, if_exists: true
    drop_table :decidim_elections_trustees, if_exists: true
    drop_table :decidim_elections_trustees_participatory_spaces, if_exists: true
    drop_table :decidim_elections_votes, if_exists: true
  end
end
