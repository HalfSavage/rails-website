class Message < ActiveRecord::Base
  attr_accessor :ignore_sender_permissions

	belongs_to :member_from, class_name: 'Member', foreign_key: 'member_from_id'
  belongs_to :member_to, class_name: 'Member', foreign_key: 'member_to_id'
  belongs_to :message_type
  belongs_to :post

  validates :member_from, presence: true
  validates :member_to, presence: true
  validates :message_type, presence: true
  validates :body, presence: true
  validate :validate_sender_has_permission_to_send
  validate :validate_sender_is_moderator
  validate :validate_not_messaging_self

  default_scope { includes(:member_to, :member_from) }

  attr_accessor :viewing_member # assumed to be the same as the person we're viewing messages for, unless a value supplied

  def obscure_content?
    return nil if @viewing_member.nil? # We don't know who's viewing, so we can't say
    return false if moderator_voice?
    @viewing_member.message_content_should_be_obscured?
  end

  def self.conversation_count_for_member(member, options = {})
    # todo: respect include_deleted
    options = {
      include_deleted: false,
      }.merge(options)
    member_id = member.to_i
    result = ActiveRecord::Base.connection.execute("select max(conversation_number) as the_count from conversations(#{member_id.to_i}, null, 'f');")
    result[0]["the_count"].to_i
  end

  def self.messages_for_members(viewing_member, other_member)
    Message.where("? in (member_from_id, member_to_id) and ? in (member_from_id, member_to_id)", viewing_member.to_i, other_member.to_i).order("id desc")
  end

  def self.conversations_for_member(member, options = {})
    options = {
      viewing_member: nil,
      page_number: 1,
      conversations_per_page: 10,
      include_deleted: false,
      eager_load: true,
      messages_per_conversation: 3
    }.merge(options)

    options[:page_number] = (options[:page_number] || 1).to_i

    member_id = member.to_i
    viewing_member = options[:viewing_member] || ((member.is_a? Member) ? member : Member.find(member_id))
    messages = Message.find_by_sql ["select * from conversations(:member_id, null, :include_deleted)
      where
        conversation_message_number <=#{options[:messages_per_conversation]}
        and (conversation_number between :first_conversation and :last_conversation)
      order by conversation_number, conversation_message_number",
      member_id: member_id,
      first_conversation: (1 + (options[:page_number]-1) * options[:conversations_per_page]),
      last_conversation: (options[:conversations_per_page] * options[:page_number]),
      include_deleted: options[:include_deleted]]
    # member = (member.is_a? Member) ? member : Member.find(member)
    messages.each { |m| m.viewing_member = viewing_member }

    # Manually eager load associations
    ActiveRecord::Associations::Preloader.new.preload(messages, [:member_from, :member_to, :post, :message_type]) if options[:eager_load]
    messages
  end

  def self.conversation_for_members(member, other_member, include_deleted = false)
    member_id = member.to_i
    other_member_id = (other_member.is_a? Member) ? other_member.id : other_member

    messages = Message.find_by_sql ["select * from conversations(:member_id, :other_member_id, :include_deleted)
      where
        and conversation_message_number <=3
        and (conversation_number between :first_conversation and :last_conversation)
      order by conversation_number", member_id: member_id, other_member_id: other_member_id, include_deleted: include_deleted.to_s.upcase]

    member = (member.is_a? Member) ? member : Member.find(member)
    messages.each { |m| m.viewing_member = member }
  end

  def self.find_for_member(member, id)
    member_id = member.to_i

    Message.where("(member_to_id=:member_id or member_from_id=:member_id)
        and ((member_to_id=:member_id and deleted_by_recipient is null) or (member_from_id=:member_id and deleted_by_sender is null))
        and id = :id", member_id: member_id, id: id)
  end

  def other_member
    return nil if viewing_member.nil?
    return member_to if viewing_member == member_from
    member_from
  end

  def from_other_member?
    return nil if viewing_member.nil?
    member_from == viewing_member
  end

  def not_moderator_voice?
    !moderator_voice?
  end

  def validate_sender_is_moderator
    errors.add(:moderator_voice, "You're not a moderator; can't send a message in moderator voice!") if moderator_voice? && member_from.not_moderator?
  end

  def validate_not_messaging_self
    errors.add(:member_to, "You're messaging yourself? Are you feeling okay?") if member_to == member_from
  end

  def validate_sender_has_permission_to_send
    return if @ignore_sender_permissions
    return unless new_record?
    if !member_from.may_send_message?
      if member_from.inactive?
        errors.add(:base, "You don't have permission to send a message, since youre account is not not active.")
        return false
      end
      if member_from.banned?
        errors.add(:base, "Oh, sure. We love when banned members send messages. We'll deliver that right away.")
        return false
      end
      if member_from.unpaid?
        # Special exception: if a mod has mod-voiced them, they may message back
        return true if Message.where(member_to: member_from, member_from: member_to, moderator_voice: true).any?
        errors.add(:base, "You may not send a private message without a paid account @ignore_sender_permissions: #{@ignore_sender_permissions}")
        return false
      end
      errors.add(:base, "You don't have permission to send a message right now.")
      return false
    end
  end
end
