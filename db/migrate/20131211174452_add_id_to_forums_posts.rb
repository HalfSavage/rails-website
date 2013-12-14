class AddIdToForumsPosts < ActiveRecord::Migration
  def change
    add_column :forums_posts, :id, :primary_key
  end
end
