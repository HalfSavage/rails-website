class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.boolean :is_active
      t.boolean :is_moderator_only
      t.boolean :is_visible_to_public
      t.boolean :is_paid_member_only

      t.timestamps
    end
  end
end
