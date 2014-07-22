class DiscussionsController < ApplicationController
  def show
    # TODO: Respect permissions/visibility for current user
    @discussion = Discussion.find_by_slug(params[:id]).first
  end
end
