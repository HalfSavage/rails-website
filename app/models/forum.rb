class Forum < ActiveRecord::Base
  include HalfSavageExceptions

  validates :name, presence: true, uniqueness: true, length: { minimum: 5, maximum: 25 }

  has_many :forums_posts
  has_many :posts, through: :forums_posts
  has_many :discussions                     # Note: the "discussions" association won't return anything for the "special" forums

  before_save :create_slug

  scope :active_public, -> { where(visible_to_public: true, active: true, special: false) }
  scope :active_moderator, -> { where(moderator_only: true, active: true, special: false) }
  scope :special, -> { where(special: true, active: true).order(:display_order) }

  def forum_permissions_check!(member = nil)
    # check permissions on forum
    fail MustNotBeBannedException "Banned members don't see forums. Sorry." if !member.nil? && member.banned?
    fail MustNotBeInactiveException "This member account is inactive." if !member.nil? && member.inactive?
    fail MustBeModeratorException "This forum is for moderators only" if moderator_only? && (member.nil? || member.not_moderator?)
    fail MustBeAuthenticatedException "This forum is for members only" if !visible_to_public? && member.nil?
    fail MustBePaidException "This forum is for paid members only" if paid_member_only? && (member.nil? || member.unpaid?)
    fail MustBeModeratorException "This forum is inactive" if inactive? && member.not_moderator?
  end

  # member can be a member_id or a Member
  def active_discussions_for_member(member = nil)
    forum_permissions_check! member

    # If it's a "special" forum, pull discussion from the appropriate place
    if special?
      case slug
      when 'all'
        return Discussion.order("coalesce(reply_created_at, created_at) desc")
      when 'most-active'
        return Discussion.most_active.order('score desc')
      when 'created-by-member'
        return Discussion.created_by(member)
      when 'recently-viewed-by-member'
        return Discussion.viewed_by(member)
      when 'newest'
        return Discussion.order("created_at desc")
      when 'active-with-friends-of-member'
        return Discussion.most_active_for_friends_of(member)
      else
        fail "Not sure how to handle the special forum '#{slug}'"
      end
    end

    # Todo: filter out posts from members ignored by member, etc.
    Discussion.where(forum: self).order("coalesce(reply_created_at, created_at) desc").includes(:member)
  end

  def create_slug
    self.slug = name.parameterize if slug.nil?
  end

  def trending_tags
    Tag.trending_in_forum(id)
  end

  def may_be_read_by(member)
    can_be_posted_in_by(member)
  end

  def may_be_posted_in_by(member)
    return false if member.nil? || member.banned? || member.inactive?
    return member.moderator? if moderator_only?
    !paid_member_only? || member.paid?
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
    Forum.where("active=true and moderator_only!=true and slug=?", slug).first
  end

  def self.regular_for_member(member)
    # No particular member (for a non-authenticated user)
    return Forum.where("active=true and special=false and visible_to_public=true").order("display_order") if member.nil? || member.inactive?

    # Moderator (can see all active forums)
    return Forum.where("active=true and special=false").order("display_order") if member.moderator?

    # Regular user (can see all non-mod forums)
    # TODO: differentiate between paid and non-paid users
    Forum.where("active=true and special=false and moderator_only!=true").order("display_order")
  end

  def self.default_forum()
    Forum.where('default_forum=true and active=true').order('display_order').first
  end

  def self.find_by_slug(slug)
    # See if it's a "normal" forum
    Forum.where('slug=?', slug)
  end

  def inactive?
    !active?
  end

  def invisible_to_public?
    !visible_to_public
  end
end
