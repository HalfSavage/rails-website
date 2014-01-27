class ForumsController < ApplicationController
  # before_action :set_forum, only: [:show]

  # GET /forums
  # GET /forums.json
  def index
    # Show them the default forum
    redirect_to controller: 'forums', action: 'show', id: Forum.default_forum.slug
  end

  # GET /forums/1
  # GET /forums/1.json
  def show  
    if (@forum = Forum.find_by_slug(params[:id]).first)
      @special_forums = Forum.special_forums
      @forums = Forum.all_for_member(current_member)
      @discussions = @forum.discussions.page(params[:page])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum      
    end
end
