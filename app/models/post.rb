class Post < ActiveRecord::Base
  # The parent is blank if it's the threads OP
  # The parent could be the OP or another post in that thread, if 
  # it's a nested reply
  belongs_to :parent, class_name: 'Post'
  has_many :replies, class_name: 'Post', foreign_key: 'parent_id'
  
  # belongs_to :thread, class_name: 'Post'
  # has_many :thread_replies, class_name: 'Post', foreign_key: 'thread_id'
  belongs_to :member
  has_many :forums_posts
  has_many :forums, -> { uniq },  through: :forums_posts  # see for explanation of uniq: http://stackoverflow.com/questions/16569994/deprecation-warning-when-using-has-many-through-uniq-in-rails-4
  has_many :post_actions

  before_save :create_slug
  after_initialize :set_defaults, on: [:create]

  # TODO: Validate subject length BUT only if parent post (replies don't need subjects)
  # validates :subject, length: {minimum: 5, maximum: 200}
  validates :body, length: {minimum: 10, maximum: 8000}
  validates :member, presence: true
  # validates :parent, presence: true  # if post is an OP, it is its own parent

  scope :discussions, -> { where(parent_id: nil) }

  def create_slug 
    self.slug = subject.parameterize if (self.subject && self.slug.nil?)
    while Post.where("slug=?",self.slug).any? do
      self.slug += ('-' + rand(0..100).to_s)
    end 
  end 

  def set_defaults
    self.is_deleted = false if (self.is_deleted.nil?)
    self.is_public_moderator_voice = false if (self.is_public_moderator_voice.nil?)
    self.is_private_moderator_voice = false if (self.is_private_moderator_voice.nil?)
  end 

  def is_thread?
    parent.nil?
  end 

  def in_public_forum? 
    return parent.in_public_forum if parent 

    forums.each { |f| 
      return true if !f.is_moderator_only
    }
    false
  end 
end
