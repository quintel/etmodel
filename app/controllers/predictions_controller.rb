class PredictionsController < ApplicationController
  before_action :find_input_element, :only => :index
  before_action :find_prediction, :only => [:show, :comment, :share]

  def index
    @predictions = @input_element.available_predictions(Current.setting.area_code)
    @prediction  = @predictions.find(params[:prediction_id]) rescue @predictions.first

    render :layout => 'iframe'
  end

  def share
    # Set the locale to nl untill en translations are available
    if english?
      I18n.locale = 'nl'
      flash[:notice] = 'Sorry, this page is only available in dutch'
    end
    @input_element = @prediction.input_element
    @predictions = @input_element.available_predictions('nl') # the area should probably be include inside the url when more then 1 area is available
    @end_year = 2050
    render :action => 'index'
  end

  def show
    I18n.locale = 'nl'
    @input_element = @prediction.input_element
    render :layout => false if request.xhr?
  end

  private

    def find_input_element
      @input_element = InputElement.find(params[:input_element_id])
    end

    def find_prediction
      @prediction = Prediction.find(params[:id])
    end
end
