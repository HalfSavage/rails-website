class MessagesController < ApplicationController
  before_action :require_authentication

  # GET /messages
  def index
    @messages = Message.conversations_for_member(current_member, {page_number: params[:page]})
    @conversation_count = Message.conversation_count_for_member(current_member)
  end

  # GET /messages/userid?messageid
  def show 
  end 


  def require_authentication
    if current_member.nil?
      flash.alert = "HalfSavage's messaging functions aren't very useful unless you've logged in."
      render template: 'shared/error'
    end 
  end 

end
