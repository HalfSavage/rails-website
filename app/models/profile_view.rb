class ProfileView < ActiveRecord::Base
  belongs_to :member
  belongs_to :viewed_member, class_name: 'Member', foreign_key: 'viewed_member_id'
end
