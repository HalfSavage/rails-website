class CreateDiscussionViews < ActiveRecord::Migration
  def change
    create_table :discussion_views do |t|
      t.references :post, index: true, null: false
      t.references :member, index: true, null: false
      t.integer :tally, null: false, default: 1

      t.timestamps
    end

    add_index :discussion_views, [:member_id, :post_id], name: 'discussion_views_idx_member_post', unique: true 
    add_index :discussion_views, [:member_id, :post_id, :updated_at, :tally], name: 'relationships_idx_covering'
  end
end
