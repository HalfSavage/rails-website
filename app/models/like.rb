class Like < ActiveRecord::Base
  belongs_to :member
  belongs_to :post

  validates :member, presence: true
  validate :must_belong_to_something

  def must_belong_to_something
    errors.add(:base, "The Like must belong to something: post, etc.") if self.post.nil?
  end 
end 