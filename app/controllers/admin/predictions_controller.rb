module Admin
class PredictionsController < BaseController

  def index
    @predictions = Prediction.all
  end

  def new
    @prediction = Prediction.new(:area => 'nl')
    @prediction.prepare_nested_attributes
  end

  def create
    @prediction = Prediction.new(params[:prediction])
    if @prediction.save
      flash[:notice] = 'Prediction was successfully created.'
      redirect_to admin_predictions_path
    else
      @prediction.prepare_nested_attributes
      render :action => 'new'
    end
  end

  def update
    @prediction = Prediction.find(params[:id])
    if @prediction.update_attributes(params[:prediction])
      flash[:notice] = 'Prediction was successfully updated.'
      redirect_to admin_predictions_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @prediction = Prediction.find(params[:id])
    if @prediction.destroy
      flash[:notice] = "Successfully destroyed prediction."
      redirect_to admin_predictions_url
    else
      flash[:error] = "Error while deleting prediction."
      redirect_to admin_predictions_url
    end
  end
  
  
  def show
    @prediction = Prediction.find(params[:id])
  end

  def edit
    @prediction = Prediction.find(params[:id])
    @prediction.prepare_nested_attributes
  end
  
end
end