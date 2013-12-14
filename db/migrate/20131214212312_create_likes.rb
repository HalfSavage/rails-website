class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :member_id
      t.integer :post_id
      t.integer :attachment_id
      t.integer :event_id
      t.timestamps
    end

    add_index :likes, [:post_id, :member_id], :unique => true
  end
end


