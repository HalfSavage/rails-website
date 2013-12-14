class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.integer :member_id_referred
      t.datetime :date_of_birth
      t.string :gender
      t.boolean :is_active
      t.boolean :is_moderator
      t.boolean :is_supermoderator
      t.boolean :is_banned
      t.boolean :is_vip
      t.boolean :is_true_successor_to_hokuto_no_ken
      t.boolean :is_visible_ti_non_members

      t.timestamps
    end
  end
end
