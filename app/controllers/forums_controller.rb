class ForumsController < ApplicationController
  # GET /forums
  def index
    # Show them the default forum
    redirect_to controller: 'forums', action: 'show', id: Forum.default_forum.slug
  end

  # GET /forums/foo
  def show
    @special_forums = Forum.special
    @forums = Forum.regular_for_member(current_member)

    if (@forum = Forum.find_by_slug(params[:id]).first)
      @discussions = @forum.active_discussions_for_member(current_member).paginate(
          page: params[:page],
          per_page: Rails.configuration.discussions_per_page
      )
    end
    # TODO: display error if forum not found
  end
end
