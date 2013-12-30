class CreateMessageTypes < ActiveRecord::Migration
  def change
    create_table :message_types do |t|
      t.string :name
    end

    create_table :messages do |t| 
      t.integer :member_to_id 
      t.integer :member_from_id 
      t.integer :message_type_id
      t.string :body, :limit => 8000
      t.datetime :seen
    end 

    add_index :messages, [:member_to_id, :message_type_id]
    # Useful for a quick "unread messages" count (?)
    add_index :messages, [:member_to_id, :seen, :message_type_id]
  end
end
