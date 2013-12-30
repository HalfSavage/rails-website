class AddPostIdToPostActions2 < ActiveRecord::Migration
  def change
    add_column :post_actions, :post_id, :integer
    add_index :post_actions, [:post_id, :post_action_type_id, :created_at], :name=>'post_actions_post_id_etc'
  end
end
