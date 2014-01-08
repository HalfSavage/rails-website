class Forum < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}
  
  has_many :forum_posts
  has_many :posts, through: :forms_posts

  after_initialize :set_defaults, on: [:create]
  before_save :create_slug

  scope :active_public, -> { where(is_visible_to_public: true, is_active: true) } 
  scope :active_moderator, -> { where(is_moderator_only: true, is_active: true) } 

  def create_slug 
    self.slug = name.parameterize if (self.slug.nil?)
  end 

  def set_defaults 
    self.is_active = true if (self.is_active.nil?)
    self.is_moderator_only = false if (self.is_moderator_only.nil?)
    self.is_visible_to_public = true if (self.is_visible_to_public.nil?)
    self.is_paid_member_only = true if (self.is_paid_member_only.nil?)
  end 

  # Returns a single forum by slug. 
  # Returns nil if forum doesn't exist OR forum exists but is inactive OR the user doesn't have permissions
  def self.find_by_slug_for_member(member, slug) 
    # No particular member (for a non-authenticated user)
    return Forum.where("is_active=true and is_visible_to_public=true and slug=?", slug).first if member.nil? || !member.is_active

    # Moderator (can see all active forums)
    return Forum.where("is_active=true and slug=?", slug).first if member.is_moderator 

    # Regular user (can see all non-mod forums)
    # TODO: differentiate between paid and non-paid users
    return Forum.where("is_active=true and is_moderator_only!=true and slug=?", slug).first
  end 

  def self.all_for_member(member) 
    # No particular member (for a non-authenticated user)
    return Forum.where("is_active=true and is_visible_to_public=true").order("display_order") if member.nil? || !member.is_active

    # Moderator (can see all active forums)
    return Forum.where("is_active=true").order("display_order") if member.is_moderator 

    # Regular user (can see all non-mod forums)
    # TODO: differentiate between paid and non-paid users
    return Forum.where("is_active=true and is_moderator_only!=true").order("display_order") 
  end
end
