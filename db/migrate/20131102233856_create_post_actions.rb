class CreatePostActions < ActiveRecord::Migration
  def change
    create_table :post_actions do |t|
      t.integer :member_id
      t.integer :post_action_type_id

      t.timestamps
    end
  end
end
