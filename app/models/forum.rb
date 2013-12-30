class Forum < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}
  
  has_many :forum_posts
  has_many :posts, through: :forms_posts

  after_initialize :set_defaults, on: [:create]

  scope :active_public, -> { where(is_visible_to_public: true, is_active: true) } 
  scope :active_moderator, -> { where(is_moderator_only: true, is_active: true) } 



  def set_defaults 
    self.is_active = true if (self.is_active.nil?)
    self.is_moderator_only = false if (self.is_moderator_only.nil?)
    self.is_visible_to_public = true if (self.is_visible_to_public.nil?)
    self.is_paid_member_only = true if (self.is_paid_member_only.nil?)
  end 
end
