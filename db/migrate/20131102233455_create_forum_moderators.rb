class CreateForumModerators < ActiveRecord::Migration
  def change
    create_table :forum_moderators do |t|
      t.string :forum_moderators
      t.integer :forum_id
      t.integer :member_id

      t.timestamps
    end
  end
end
