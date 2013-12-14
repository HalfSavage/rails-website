class Post < ActiveRecord::Base
  has_many :replies, class_name: 'Post', foreign_key: 'reply_to_post_id'
  belongs_to :parent, class_name: 'Member'
  belongs_to :member
  has_many :forums_posts
  has_many :forums, -> { uniq },  through: :forums_posts  # see for explanation of uniq: http://stackoverflow.com/questions/16569994/deprecation-warning-when-using-has-many-through-uniq-in-rails-4


  after_initialize :set_defaults, on: [:create]

  validates :subject, length: {minimum: 5, maximum: 200}
  validates :body, length: {minimum: 10, maximum: 4000}
  validates :member, presence: true
  # validates :parent, presence: true  # if post is an OP, it is its own parent


  def set_defaults
    self.is_deleted = false if (self.is_deleted.nil?)
    self.is_public_moderator_voice = false if (self.is_public_moderator_voice.nil?)
    self.is_private_moderator_voice = false if (self.is_private_moderator_voice.nil?)
  end 
end
