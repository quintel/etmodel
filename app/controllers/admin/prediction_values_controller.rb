class Admin::PredictionValuesController < Admin::AdminController
  def index
    @prediction_values = PredictionValue.all
  end

  def new
    @prediction_value = PredictionValue.new
  end

  def create
    @prediction_value = PredictionValue.new(params[:prediction_value])
    if @prediction_value.save
      flash[:notice] = "PredictionValue saved"
      redirect_to :back
    else
      render :action => 'new'
    end
  end
    
  def update
    @prediction_value = PredictionValue.find(params[:id])
    if @prediction_value.update_attributes(params[:prediction_value])
      flash[:notice] = "PredictionValue updated"
      redirect_to :back
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @prediction_value = PredictionValue.find(params[:id])
    if @prediction_value.destroy
      flash[:notice] = "Successfully destroyed historic serie."
      redirect_to admin_prediction_values_url
    else
      flash[:error] = "Error while deleting historic serie."
      redirect_to admin_prediction_values_url
    end
  end


  def show
    find_model
  end

  def edit
    find_model
  end
  
  def find_model
    if params[:version_id]
      @version = Version.find(params[:version_id])
      @prediction_value = @version.reify
      flash[:notice] = "Revision"
    else
      @prediction_value = PredictionValue.find(params[:id])
    end
  end
end
