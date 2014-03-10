class ProfileViewsController < ApplicationController
  before_action :set_profile_view, only: [:show, :edit, :update, :destroy]

  # GET /profile_views
  # GET /profile_views.json
  def index
    @profile_views = ProfileView.all
  end

  # GET /profile_views/1
  # GET /profile_views/1.json
  def show
  end

  # GET /profile_views/new
  def new
    @profile_view = ProfileView.new
  end

  # GET /profile_views/1/edit
  def edit
  end

  # POST /profile_views
  # POST /profile_views.json
  def create
    @profile_view = ProfileView.new(profile_view_params)

    respond_to do |format|
      if @profile_view.save
        format.html { redirect_to @profile_view, notice: 'Profile view was successfully created.' }
        format.json { render action: 'show', status: :created, location: @profile_view }
      else
        format.html { render action: 'new' }
        format.json { render json: @profile_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_views/1
  # PATCH/PUT /profile_views/1.json
  def update
    respond_to do |format|
      if @profile_view.update(profile_view_params)
        format.html { redirect_to @profile_view, notice: 'Profile view was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @profile_view }
      else
        format.html { render action: 'edit' }
        format.json { render json: @profile_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_views/1
  # DELETE /profile_views/1.json
  def destroy
    @profile_view.destroy
    respond_to do |format|
      format.html { redirect_to profile_views_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_view
      @profile_view = ProfileView.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_view_params
      params.require(:profile_view).permit(:member_id, :member_id, :tally)
    end
end
