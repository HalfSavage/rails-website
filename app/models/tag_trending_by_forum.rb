class TagTrendingByForum < ActiveRecord::Base
  # It maps to a view, actually. Magical!
  self.table_name = "tags_trending_by_forum"
  self.primary_key = :tag_id

  belongs_to :forum 
end