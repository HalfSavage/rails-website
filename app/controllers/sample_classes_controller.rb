class SampleClassesController < ApplicationController
  before_action :set_sample_class, only: [:show, :edit, :update, :destroy]

  # GET /sample_classes
  # GET /sample_classes.json
  def index
    @sample_classes = SampleClass.all
  end

  # GET /sample_classes/1
  # GET /sample_classes/1.json
  def show
  end

  # GET /sample_classes/new
  def new
    @sample_class = SampleClass.new
  end

  # GET /sample_classes/1/edit
  def edit
  end

  # POST /sample_classes
  # POST /sample_classes.json
  def create
    @sample_class = SampleClass.new(sample_class_params)

    respond_to do |format|
      if @sample_class.save
        format.html { redirect_to @sample_class, notice: 'Sample class was successfully created.' }
        format.json { render :show, status: :created, location: @sample_class }
      else
        format.html { render :new }
        format.json { render json: @sample_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sample_classes/1
  # PATCH/PUT /sample_classes/1.json
  def update
    respond_to do |format|
      if @sample_class.update(sample_class_params)
        format.html { redirect_to @sample_class, notice: 'Sample class was successfully updated.' }
        format.json { render :show, status: :ok, location: @sample_class }
      else
        format.html { render :edit }
        format.json { render json: @sample_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sample_classes/1
  # DELETE /sample_classes/1.json
  def destroy
    @sample_class.destroy
    respond_to do |format|
      format.html { redirect_to sample_classes_url, notice: 'Sample class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample_class
      @sample_class = SampleClass.find(params[:id])
    end
    
    def sample_class_params
      params.require(:sample_class).permit(:description, :number_of_bloits)
    end
end
