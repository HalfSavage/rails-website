class ForumsController < ApplicationController
  # before_action :set_forum, only: [:show]

  # GET /forums
  # GET /forums.json
  def index
    @forums = Forum.all
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
    # Todo: Get a list of forums visible to this user

    if !current_member then 
      render inline: "Fuck off" 
      return 
    end 

    # Todo: Is this forum visible to this user?
    @forum = Forum.where('slug=?',params[:id]).first
    if @forum then 
      render inline: "This is fucking forum #{params[:id]}"
    else 
      render inline: "Never heard of that forum. Sorry."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum      
    end
end
