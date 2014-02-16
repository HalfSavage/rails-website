class Post < ActiveRecord::Base
  # The parent could be the OP or another post in that thread, if 
  # it's a nested reply
  belongs_to :parent, class_name: 'Post'
  has_many :replies, class_name: 'Post', foreign_key: 'parent_id'
  
  # Relations
  belongs_to :member
  has_many :forums_posts
  has_many :forums, -> { uniq },  through: :forums_posts  # see for explanation of uniq: http://stackoverflow.com/questions/16569994/deprecation-warning-when-using-has-many-through-uniq-in-rails-4
  has_many :post_actions
  # TODO: add relation to PostTag and Tag (through PostTag)

  # Hooks
  before_save :create_slug
  after_save :update_tags
  after_initialize :set_defaults, on: [:create]

  # TODO: Validate subject length BUT only if parent post (replies don't need subjects)
  # validates :subject, length: {minimum: 5, maximum: 200}
  validates :body, length: {minimum: 10, maximum: 8000}
  validates :member, presence: true

  # Scopes
  scope :discussions, -> { where(parent_id: nil) }

  # If this is a thread, create a slug... ie a version of the thread subject
  # that we can put in the URL so that we can have pretty, Google-able URLs
  # like http://halfsavage.com/discussions/why-does-my-poop-smell or whatever
  def create_slug 
    self.slug = subject.parameterize if (self.subject && self.slug.nil?)
    while Post.where("slug=?",self.slug).any? do
      self.slug += ('-' + rand(0..100).to_s)
    end 
  end 

  def update_tags 
    # Just delete all existing tags. This is inefficient obviously... eventually we'll want 
    # to just delete the tags that are no longer in the post. But this only happens once,
    # when a post is saved, so whatever.
    PostsTag.delete_all(post_id: id)
    log = ''

    # Pull all the hashtags out into array via regex
    tags = body.scan(/(?:(?<=\s)|^)#(\w*[A-Za-z_]+\w*)/)
    #debugger
    # We need a unique, case-insensitive list of tags
    # tags.uniq! would be case-sensitive but luckly .uniq and .uniq! can accept a block
    tags.flatten!
    tags.uniq!{ |elem| elem.downcase }  
  
    # todo: this should be a configurable setting somewhere.
    # We'll only parse the first max_tags_per_post tags because unlike a single tweet,
    # you could stuff a truly obnoxious number of tags into a single post
    max_tags_per_post = 10
    
    # There is probably a much more Ruby-ish way of doing this loop :)
    count=0
    tags.each{ |tag_text| 
      if (count<max_tags_per_post) then
        tag = Tag.find_by_tag_or_new(tag_text)
        tag.created_at = self.created_at
        tag.save
        post_tag = PostsTag.new({tag: tag, post: self})
        begin 
          post_tag.save
        rescue Exception=>e 
          puts "Fuck. Tags: #{tags} Current: #{tag_text}"
          puts e
          debugger
        end 
        count+=1
      end 
    }
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
