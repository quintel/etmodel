class PredictionsController < ApplicationController
  def index
    @input_element = InputElement.find(params[:input_element_id])
    @prediction = @input_element.predictions.first
  end
  
  def show
    @prediction = Prediction.find params[:id]
    render :layout => false if request.xhr?    
  end
end
