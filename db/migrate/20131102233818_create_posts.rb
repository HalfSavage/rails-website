class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :thread_id
      t.integer :member_id
      t.integer :reply_to_post_id
      t.boolean :is_deleted
      t.boolean :is_public_moderator_voice
      t.boolean :is_private_moderator_voice
      t.boolean :body
      t.datetime :marked_as_answer

      t.timestamps
    end
  end
end
