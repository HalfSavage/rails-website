class Member < ActiveRecord::Base
  include ActionView::Helpers # we need the truncate function

  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Relations
  belongs_to :gender
  belongs_to :referred_by, class_name: 'Member'
  has_many :referrals, class_name: 'Member', foreign_key: 'member_id_referred'
  has_one :address

  # Validations
  validates :username, uniqueness: { case_sensitive: false }
  validates :gender, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :date_of_birth, presence: true
  validates :username, length: { minimum: 5, maximum: 30 }
  # validates :username_slug, presence: true

  # Scopes
  scope :moderators, -> { where(moderator: true) }
  scope :supermoderators, -> { where(supermoderator: true) }
  scope :paid, -> { where(paid: true) }
  scope :active, -> { where(active: true) }
  scope :unbanned, -> { where(banned: false) }

  # Hooks
  before_save :username_to_slug

  # Have to override this to allow login by email OR username (Devise default is email only)
  # See: https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def to_i
    id
  end

  def unpaid?
    !paid?
  end

  def not_moderator?
    !moderator?
  end

  def not_supermoderator?
    !supermoderator
  end

  def inactive?
    !active
  end

  def may_not_send_message?
    !may_send_message?
  end

  def may_send_message?
    active? && (!banned) && (paid? || moderator?)
  end

  def message_content_should_be_obscured?
    unpaid? && not_moderator?
  end

  def message_content_should_not_be_obscured?
    !message_content_should_be_obscured
  end

  # For cached global objects whose content depends on their entitlements
  # Most obvious example is the forum list on the left side of the forums
  def member_entitlements_cache_key
    "#{banned?}_#{active?}_#{paid?}_#{moderator?}_#{supermoderator?}"
  end

  # todo: should be in helper that re-opens member class?
  def username_and_first_name
    if first_name.nil?
      username
    else
      "#{username} (#{first_name})"
    end
  end

  # premature optimization? good idea? avoid a zillion lookups on the genders table.
  def gender_description
    case gender_id
    when 1
      'Male'
    when 2
      'Female'
    when 3
      'It''s complicated'
    end
  end

  # premature optimization? good idea? avoid a zillion lookups on the genders table.
  def gender_abbreviation
    case gender_id
    when 1
      'M'
    when 2
      'F'
    when 3
      ''
    end
  end

  # todo: should be in helper that re-opens member class?
  # todo: handle non-US locations (display country code, if user is in country other than one's own country)
  # todo: handle missing addresses
  # todo: handle permissions (does viewing member have permission to view this person's address?)
  # todo: show distance between viewing member and member being viewed
  def age_gender_location
    if gender_id > 2
      "#{age}, #{address.city} #{address.region}"
    else
      "#{age}, #{gender_description}, #{address.city} #{address.region}"
    end
  end

  def messages_with(other_member)
    Message.messages_for_members(self, other_member).each do |m|
      m.viewing_member = self
    end
  end

  def username_to_slug
    if self.new_record? || self.username_changed?
      self.username_slug = self.username.parameterize
      self.username_slug = truncate(self.username_slug, omission: '', length: 100)
      # Ensure uniqueness of slug; this could DEFINITELY be less ugly!
      while Member.where("username_slug=? and id<>coalesce(?,-1)", username_slug, id).any?
        self.username_slug += ('-' + rand(0..100).to_s)
      end
    end
  end

  # from: http://stackoverflow.com/questions/1904097/how-to-calculate-how-many-years-passed-since-a-given-date-in-ruby
  def age(the_date = Time.now)
    # Difference in years, less one if you have not had a birthday this year.
    a = the_date.year - date_of_birth.year
    a -= 1 if the_date.month >  date_of_birth.month || (the_date.month >= date_of_birth.month && the_date.day > date_of_birth.day)
    a
  end

end
