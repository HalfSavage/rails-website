class Relationship < ActiveRecord::Base
  belongs_to :member
  belongs_to :related_member, class_name: 'Member', foreign_key: 'related_member_id'
end
