class FixForumsPostsIndexes < ActiveRecord::Migration
  def change
    remove_index(:forums_posts, name: 'index_forums_posts_on_forum_id')
    remove_index(:forums_posts, name: 'index_forums_posts_on_post_id')
    add_index :forums_posts, [ :forum_id, :post_id ], :unique => true, :name => 'by_forum_and_post'
  end
end
