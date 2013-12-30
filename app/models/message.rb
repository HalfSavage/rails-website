class Message < ActiveRecord::Base
	belongs_to :member_from, class_name: 'Member', foreign_key: 'member_to_id'
  belongs_to :member_to, class_name: 'Member', foreign_key: 'member_from_id'
  belongs_to :message_type
  belongs_to :post

  validates :member_from, presence: true
  validates :member_to, presence: true 
  validates :message_type, presence: true
end
