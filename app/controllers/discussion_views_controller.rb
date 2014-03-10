class DiscussionViewsController < ApplicationController
  before_action :set_discussion_view, only: [:show, :edit, :update, :destroy]

  # GET /discussion_views
  # GET /discussion_views.json
  def index
    @discussion_views = DiscussionView.all
  end

  # GET /discussion_views/1
  # GET /discussion_views/1.json
  def show
  end

  # GET /discussion_views/new
  def new
    @discussion_view = DiscussionView.new
  end

  # GET /discussion_views/1/edit
  def edit
  end

  # POST /discussion_views
  # POST /discussion_views.json
  def create
    @discussion_view = DiscussionView.new(discussion_view_params)

    respond_to do |format|
      if @discussion_view.save
        format.html { redirect_to @discussion_view, notice: 'Discussion view was successfully created.' }
        format.json { render action: 'show', status: :created, location: @discussion_view }
      else
        format.html { render action: 'new' }
        format.json { render json: @discussion_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discussion_views/1
  # PATCH/PUT /discussion_views/1.json
  def update
    respond_to do |format|
      if @discussion_view.update(discussion_view_params)
        format.html { redirect_to @discussion_view, notice: 'Discussion view was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @discussion_view }
      else
        format.html { render action: 'edit' }
        format.json { render json: @discussion_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussion_views/1
  # DELETE /discussion_views/1.json
  def destroy
    @discussion_view.destroy
    respond_to do |format|
      format.html { redirect_to discussion_views_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion_view
      @discussion_view = DiscussionView.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_view_params
      params.require(:discussion_view).permit(:post_id, :member_id, :tally)
    end
end
