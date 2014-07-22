class Message < ActiveRecord::Base
	belongs_to :member_from, class_name: 'Member', foreign_key: 'member_from_id'
  belongs_to :member_to, class_name: 'Member', foreign_key: 'member_to_id'
  belongs_to :message_type
  belongs_to :post

  validates :member_from, presence: true
  validates :member_to, presence: true 
  validates :message_type, presence: true
  validate :sender_has_permission_to_send?

  attr_accessor :viewing_member 

  def obscure_content? 
    return nil if @viewing_member.nil? # We don't know who's viewing, so we can't say
    return false if moderator_voice?
    @viewing_member.message_content_should_be_obscured?
  end 

  # Excludes deleted messages
  def self.conversations_for_member(member, viewing_member = nil)
    member_id = (member.is_a? Member) ? member.id : member 
    viewing_member = viewing_member || ((member.is_a? Member) ? member : Member.find(member_id))

    messages = Message.find_by_sql ["select * from conversations 
      where 
        (member_to_id=:member_id or member_from_id=:member_id) 
        and ((member_to_id=:member_id and deleted_by_recipient is null) or (member_from_id=:member_id and deleted_by_sender is null))
        and conversation_message_number <=3
      order by conversation_number, conversation_message_number", member_id: member_id]
    messages.each { |m| m.viewing_member = viewing_member } 
  end 

  def self.conversation_for_members(member, other_member)
    member_id = (member.is_a? Member) ? member.id : member 
    other_member_id = (other_member.is_a? Member) ? other_member.id : other_member
    
    messages = conversation_for_members_include_deleted(member_id, other_member_id)
    messages.where("((member_to_id=:member and deleted_by_recipient is null) or (member_from_id=:other_member_id and deleted_by_sender is null))")
    messages.each { |m| m.viewing_member = member } 
  end 

  def self.conversation_for_members_include_deleted(member, other_member)
    member_id = (member.is_a? Member) ? member.id : member 
    other_member_id = (other_member.is_a? Member) ? other_member.id : other_member

    Message.where("(member_to_id in (:member_id,:other_member_id) and member_from_id in (:member_id,:other_member_id))",
      member_id: member_id,
      other_member_id: other_member_id
      ).order(created_at: :desc)
  end 

  def self.find_for_member(member, id)
    member_id = (member.is_a? Member) ? member.id : member 

    Message.where("(member_to_id=:member_id or member_from_id=:member_id) 
        and ((member_to_id=:member_id and deleted_by_recipient is null) or (member_from_id=:member_id and deleted_by_sender is null))
        and id = :id", member_id: member_id, id: id)
  end 

  def not_moderator_voice?
    !moderator_voice?
  end 

  def sender_has_permission_to_send?
    return true if !new_record?
    return false if member_from.nil?
    member_from.permission_to_send_message?
  end 

end
