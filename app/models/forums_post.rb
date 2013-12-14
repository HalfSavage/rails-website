class ForumsPost < ActiveRecord::Base
  belongs_to :forum 
  belongs_to :post

  # Todo: Should probably have timestamps and an associated Member
  # so we can say e.g. when a post has been moved/x-posted to a different
  # forum by a moderator
end