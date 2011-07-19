class PredictionsController < ApplicationController

  def index
    @InputElement = InputElement.find(params[:input_element_id])
  end
  
end
