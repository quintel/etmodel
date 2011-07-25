class PredictionsController < ApplicationController
  def index
    @input_element = InputElement.find(params[:input_element_id])
  end
end
