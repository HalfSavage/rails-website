class CreatePostActionTypes < ActiveRecord::Migration
  def change
    create_table :post_action_types do |t|
      t.string :name
      t.boolean :moderator_only, :active
      t.timestamps
    end
  end
end
