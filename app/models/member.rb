class Member < ActiveRecord::Base
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Filters
  after_initialize :foo, on: [:create]

  # Relations
  belongs_to :gender
  has_many :referrals, class_name: 'Member', foreign_key: 'member_id_referred'
  belongs_to :referred_by, class_name: 'Member' 

  # Validations
  validates :username, uniqueness: {case_sensitive: false}
  validates :gender, presence: true
  validates :email, uniqueness: {case_sensitive: false}
  validates :date_of_birth, presence: true
  validates :username, length: { minimum: 5, maximum: 30}

  scope :moderators, -> { where(is_moderator: true) } 
  scope :supermoderators, -> { where(is_supermoderator: true) }

  # Have to override this to allow login by email OR username (Devise default is email only)
  # See: https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  protected

  def foo
    self.is_active = true if (self.is_active.nil?)
    self.is_moderator = false if (self.is_moderator.nil?)
    self.is_supermoderator = false if (self.is_supermoderator.nil?)
    self.is_banned = false if (self.is_banned.nil?)
    self.is_vip = false if (self.is_vip.nil?)
    self.is_true_successor_to_hokuto_no_ken = false if (self.is_true_successor_to_hokuto_no_ken.nil?)
    self.is_visible_to_non_members = false if (self.is_visible_to_non_members.nil?)
  end

end
