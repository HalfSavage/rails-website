class Discussion < ActiveRecord::Base
  belongs_to :forum 

  # TODO: fix view to keep duplicates out (if a thread is in > 1 forums it will show up twice, I think)
  scope :most_active, -> {
    joins("inner join discussions_active on discussions_active.id = discussions.id").order("score desc")
  }

  def self.viewed_by(member)
    member_id = (member.is_a? Member) ? member.id : member
    raise Exception.new "Can't return recently-viewed discussions without a valid Member or member_id" if member_id.nil?
    where("id in (select post_id from discussion_views where member_id=#{sanitize(member_id)})").order("coalesce(reply_created_at, created_at) desc")
  end  

  def self.posted_in_by(member)
    member_id = (member.is_a? Member) ? member.id : member
    raise Exception.new "Can't return recently-posted-in discussions without a valid Member or member_id" if member_id.nil?
    where("id in (select parent_id from posts where member_id=#{sanitize(member_id)}) or id in (select id from posts where member_id=#{sanitize(member_id)} and parent_id is null)").order("coalesce(reply_created_at, created_at) desc")
  end 

  def self.most_active_for_friends_of(member)
    member_id = (member.is_a? Member) ? member.id : member
    raise Exception.new "Can't return active friends' discussions without a valid Member or member_id" if member_id.nil?
    from("discussions_active_friends(#{sanitize(member_id)}) as discussions").order("score desc")
  end 

  def self.created_by(member)
    member_id = (member.is_a? Member) ? member.id : member
    raise Exception.new "Can't return recently-created discussions without a valid Member or member_id" if member_id.nil?
    where(member_id: member_id)
  end 
end 