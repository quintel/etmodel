module Admin
class PredictionValuesController < BaseController

  def new
    @prediction_value = PredictionValue.new
  end

  def create
    @prediction_value = PredictionValue.new(params[:prediction_value])
    if @prediction_value.save
      flash[:notice] = "PredictionValue saved"
      redirect_to admin_prediction_path(@prediction_value.prediction)
    else
      render :action => 'new'
    end
  end
    
  def update
    @prediction_value = PredictionValue.find(params[:id])
    if @prediction_value.update_attributes(params[:prediction_value])
      flash[:notice] = "PredictionValue updated"
      redirect_to admin_prediction_path(@prediction_value.prediction)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @prediction_value = PredictionValue.find(params[:id])
    if @prediction_value.destroy
      flash[:notice] = "Successfully destroyed PredictionValue."
      redirect_to admin_predictions_url
    else
      flash[:error] = "Error while deleting PredictionValue."
      redirect_to admin_predictions_url
    end
  end

  def edit
    @prediction_value = PredictionValue.find(params[:id])
  end
  
  def show
    @prediction_value = PredictionValue.find(params[:id])
  end
  
end
end