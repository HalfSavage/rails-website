class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string  :tag
      t.timestamps
    end
    add_index :tags, :tag, :unique => true

    # primary key really should be post_id+tag_id
    create_table :posts_tags, {:id => false} do |t|
      t.integer :post_id
      t.integer :tag_id
      t.timestamps 
    end 
    execute "ALTER TABLE posts_tags ADD PRIMARY KEY (post_id,tag_id);"

  end

  def down 
    drop_table :posts_tags
    drop_table :tags
  end 
end
