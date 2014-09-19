class MessagesController < ApplicationController
  before_action :require_authentication

  # GET /messages
  def index
    @messages = Message.conversations_for_member(current_member, {page_number: params[:page]})
    @conversation_count = Message.conversation_count_for_member(current_member)
  end

  # GET /messages/username_slug?messageid
  def show 
    @other_member = Member.where(username_slug: params[:id]).first
    @messages = current_member.messages_with(@other_member)
  end 

  def create 
    @message = Message.new(message_params)
    @message.member_from = current_member
    @message.message_type_id = 1
    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully saved, buddy.' }
        # format.json { render :show, status: :created, location: @message }
        format.json { render partial: 'messages.html.erb', status: :created, location: @message }
      else
        # debugger
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end 

  def require_authentication
    if current_member.nil?
      flash.alert = "HalfSavage's messaging functions aren't very useful unless you've logged in."
      render template: 'shared/error'
    end 
  end 

private 

  def message_params
    if current_member.moderator?
      params.require(:message).permit(:body, :member_to_id, :moderator_voice)
    else 
      params.require(:message).permit(:body, :member_to_id)
    end 
  end

end
