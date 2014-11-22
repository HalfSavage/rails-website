# Uses the composite_primary_keys gem
# See: https://github.com/composite-primary-keys/composite_primary_keys
# Can use composite find() like Post_Tag.find(123,456)

class PostTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :post
	primary_keys = :post_id, :tag_id
end
