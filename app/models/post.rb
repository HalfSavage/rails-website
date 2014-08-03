
class Post < ActiveRecord::Base
  include ActionView::Helpers # we need the truncate function

  # The parent could be the OP or another post in that thread, if
  # it's a nested reply
  belongs_to :parent, class_name: 'Post'
  has_many :replies, class_name: 'Post', foreign_key: 'parent_id'

  # Relations
  belongs_to :member
  has_many :forums_posts #, autosave: true
  # has_many :forums, -> { uniq },  through: :forums_posts  # see for explanation of uniq: http://stackoverflow.com/questions/16569994/deprecation-warning-when-using-has-many-through-uniq-in-rails-4
  has_many :forums,  through: :forums_posts  # see for explanation of uniq: http://stackoverflow.com/questions/16569994/deprecation-warning-when-using-has-many-through-uniq-in-rails-4
  has_many :post_actions

  # TODO: add relation to PostTag and Tag (through PostTag)

  # Hooks
  before_validation :create_slug, if: :discussion_parent?
  before_save :check_if_tags_need_to_be_deleted
  after_save :update_tags, if: :discussion_parent?

  # Validations that always happen
  # TODO: Validate duplicate posts by a single member
  validates :body, length: {minimum: 10, maximum: 8000}
  validates :member, presence: true
  validate :member_may_post_in_forum
  validate :discussion_belongs_to_forum

  # Validations that apply only if this post is the parent of a new discussion (a.k.a. "thread")
  validates :subject, length: {minimum: 5, maximum: 200}, if: :discussion_parent?
  validates_presence_of :forums_posts, if: :discussion_parent?, message: "...discussion must belong to some forums"
  validates_presence_of :subject, if: :discussion_parent?
  validates_presence_of :slug, if: :discussion_parent?

  # Validations that apply only if this post isn't the parent of discussion
  # Should we cover these possibilities with tests instead of validations?
  validates_absence_of :forums_posts, unless: :discussion_parent?
  validates_absence_of :subject, unless: :discussion_parent?
  validates_absence_of :slug, unless: :discussion_parent?

  # Scopes
  scope :discussions, -> { where(parent_id: nil) }
  scope :by_discussion_slug, ->(slug) { where("(select id from posts where slug=?) in (id, parent_id)", slug) }
  scope :not_deleted, -> { where(deleted: false) }

  # If this is a thread, create a slug... ie a version of the thread subject
  # that we can put in the URL so that we can have pretty, Google-able URLs
  # like http://halfsavage.com/discussions/why-does-my-poop-smell or whatever
  def create_slug
    if self.subject.present? && self.slug.blank?
      self.slug = subject.parameterize
      self.slug = truncate(self.slug, omission: '', length: Rails.configuration.discussion_slug_length, separator: ' ')
    end
    # Ensure uniqueness of slug; this could probably be less ugly!
    while Post.where("slug=? and id<>coalesce(?,-1)", self.slug, self.id).any? do
      self.slug += ('-' + rand(0..100).to_s)
    end
  end

  def check_if_tags_need_to_be_deleted
    @was_a_new_record = self.new_record?
  end

  def update_tags
    # Just delete all existing tags. This is inefficient obviously... eventually we'll want
    # to just delete the tags that are no longer in the post. But this only happens when a post
    # is updated, not during the first time it's saved, so no biggie
    PostTag.delete_all(post_id: id) unless @was_a_new_record

    # Pull all the hashtags out into array via regex
    tags = body.scan(/(?:(?<=\s)|^)#(\w*[A-Za-z_]+\w*)/)

    # We need a unique, case-insensitive list of tags
    # tags.uniq! would be case-sensitive but luckly .uniq and .uniq! can accept a block
    tags.flatten!
    tags.uniq!{ |elem| elem.downcase }

    # We'll only parse the first max_tags_per_post tags because unlike a single tweet,
    # you could stuff a truly obnoxious number of tags into a single post
    tags.take(MAX_TAGS_PER_POST).each{ |tag_text|
      tag = Tag.find_by_tag_or_new(tag_text)
      tag.save! if tag.new_record?
      PostTag.create!({tag: tag, post: self, created_at: self.created_at})
    }
  end

  def discussion_parent?
    return true if parent_id.nil?
    return true if parent_id == id
    false
  end

  def in_public_forum?
    return parent.in_public_forum? if parent
    in_at_least_one_public_forum?
  end

  # Is the post in at least a single non-moderator forum?
  # Posts/discussions in multiple forums can be replied to by non-mods,
  # as long as the post is in at least one non-moderator forum
  def in_at_least_one_public_forum?
    return parent.in_public_forum? if parent
    forums.each { |f| return true if !f.moderator_only? }
    false
  end

  def only_in_moderator_forums?
    !in_at_least_one_public_forum?
  end

  def discussion_belongs_to_forum
    errors[:base] << "Discussion must belong to at least one forum" if discussion_parent? && forums.none?
  end


private
  def member_may_post_in_forum
    return nil if forums.nil?
    errors[:base] << "Banned members can't post in forums" if member.banned?
    errors[:base] << "Inactive members can't post in forums" if member.inactive?

    if self.discussion_parent?
      the_forums = forums
    else
      the_forums = parent.forums
    end
    errors[:forums] << 'Post... seems to have no forums? Whaaa? Huh...' if the_forums.blank?

    # if forum is paid-only, is member paid?
    # note: if discussion exists in multiple forums, user only needs permission for one of them!
    has_permission = false
    the_forums.each do |f|
      has_permission = true if f.may_be_posted_in_by(member)
    end
    errors[:base] << 'You don''t have permission to post in this forum.' unless has_permission
  end

end
