class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :member_id
      t.integer :message_type_id
      t.string :body
      t.boolean :seen

      t.timestamps
    end
  end
end
