module Admin
class PredictionMeasuresController < BaseController

  def new
    @prediction_measure = PredictionMeasure.new
  end

  def create
    @prediction_measure = PredictionMeasure.new(params[:prediction_measure])
    if @prediction_measure.save
      flash[:notice] = "PredictionMeasure saved"
      redirect_to admin_prediction_path(@prediction_measure.prediction)
    else
      render :action => 'new'
    end
  end
    
  def update
    @prediction_measure = PredictionMeasure.find(params[:id])
    if @prediction_measure.update_attributes(params[:prediction_measure])
      flash[:notice] = "PredictionMeasure updated"
      redirect_to admin_prediction_path(@prediction_measure.prediction)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @prediction_measure = PredictionMeasure.find(params[:id])
    if @prediction_measure.destroy
      flash[:notice] = "Successfully destroyed PredictionMeasure."
      redirect_to admin_predictions_url
    else
      flash[:error] = "Error while deleting PredictionMeasure."
      redirect_to admin_predictions_url
    end
  end

  def edit
    @prediction_measure = PredictionMeasure.find(params[:id])
  end
  
  def show
    @prediction_measure = PredictionMeasure.find(params[:id])
  end
  
end
end