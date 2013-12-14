class AddPostReplyIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :reply_to_post_id, :integer
  end
end
