class PostAction < ActiveRecord::Base
  validates :member_id, :post_id, :post_action_type_id, presence: true
  validate :member_must_have_proper_permissions
  belongs_to :member
  belongs_to :post
  belongs_to :post_action_type

  def member_must_have_proper_permissions
    return if post_action_type.nil?
    return if member.nil?

    # Member can't use moderator-only actions
    if post_action_type.moderator_only && !member.is_moderator
      errors.add(:post_action_type, 'is only available to moderators')
    end

    # Post must be in at least one public forum if member's not a mod
    errors.add(:base, 'This post is not in a public forum') if !member.is_moderator && post.in_public_forum?
  end
end
