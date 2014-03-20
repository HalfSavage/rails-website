class Forum < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}
  
  has_many :forums_posts
  has_many :posts, through: :forums_posts
  has_many :discussions

  before_save :create_slug

  scope :active_public, -> { where(is_visible_to_public: true, is_active: true) } 
  scope :active_moderator, -> { where(is_moderator_only: true, is_active: true) } 

  def create_slug 
    self.slug = name.parameterize if (self.slug.nil?)
  end 

  def trending_tags
    Tag.trending_in_forum(id)
  end 

  # Returns a single forum by slug. 
  # Returns nil if forum doesn't exist OR forum exists but is inactive OR the user doesn't have permissions
  def self.find_by_slug_for_member(member, slug) 
    # No particular member (for a non-authenticated user)
    return Forum.where("active=true and visible_to_public=true and slug=?", slug).first if member.nil? || !member.is_active

    # Moderator (can see all active forums)
    return Forum.where("active=true and slug=?", slug).first if member.is_moderator 

    # Regular user (can see all non-mod forums)
    # TODO: differentiate between paid and non-paid users
    return Forum.where("active=true and moderator_only!=true and slug=?", slug).first
  end 

  def self.all_for_member(member) 
    # No particular member (for a non-authenticated user)
    return Forum.where("active=true and visible_to_public=true").order("display_order") if member.nil? || !member.is_active

    # Moderator (can see all active forums)
    return Forum.where("active=true").order("display_order") if member.is_moderator 

    # Regular user (can see all non-mod forums)
    # TODO: differentiate between paid and non-paid users
    return Forum.where("active=true and moderator_only!=true").order("display_order") 
  end

  def self.default_forum() 
    Forum.where('default_forum=true and active=true').order('display_order').first
  end 

  def self.find_by_slug(slug)
    # See if it's a "special forum"
    
    # See if it's a "normal" forum
    Forum.where('slug=?',slug)
  end 

  def threads

  end 

  def self.special_forums
    {
      :'most-active' => 'Most Active Topics',
      :'all-topics' => 'All Topics', 
      :'topics-you-created' => 'Topics You Created',
      :'recently-viewed-topics' => 'Recently Viewed Topics',
      :'newest-topics' => 'Newest Topics',
      :'unanswered-questions' => 'Unanswered Questions',
      :'topics-friends-are-active-in' => 'Topics Your Friends Are Active In'
    }
  end 
end
