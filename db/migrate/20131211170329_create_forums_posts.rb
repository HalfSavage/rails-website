class CreateForumsPosts < ActiveRecord::Migration
  def change
    create_join_table :forums, :posts do |t|
      t.index :forum_id
      t.index :post_id
    end
  end
end
