class ChangeTrendingTagsToTrendingTagsByForum < ActiveRecord::Migration
  def self.up
    execute 'alter view tags_trending rename to tags_trending_by_forum;'
  end

  def self.down
    execute 'alter view tags_trending_by_forum rename to tags_trending;'
  end
end
