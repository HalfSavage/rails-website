module MemberHelper
  def member_link(member)
    if member.is_a? Member 
      return "<a href=\"fart\" class=\"member_link\"><i class=\"fa fa-user\"></i> #{member.username}</a>".html_safe
    else
      return "<a href=\"poop\" class=\"member_link\"><i class=\"fa fa-user\"></i> #{member}</a>".html_safe
    end 
  end 
end
