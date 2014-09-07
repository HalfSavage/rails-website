module MemberHelper
  def member_link(member, options={})
    options = {
      show_icon: true,
      include_first_name: false
      }.merge(options)
      
    if member.is_a? Member 
      display_name = options[:include_first_name] ? member.username : member.username_and_firstname
      return "<a href=\"members/#{member.username_slug}\" class=\"member_link\"><i class=\"fa fa-user\"></i> #{display_name}</a>".html_safe
    else
      return "<a href=\"members/#{member.username_slug}\" class=\"member_link\"><i class=\"fa fa-user\"></i> #{member}</a>".html_safe
    end 
  end 
end
