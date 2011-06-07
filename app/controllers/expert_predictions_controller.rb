class ExpertPredictionsController < ApplicationController
  
  ## This method is called by ajax. It updates the given slider with the value from the db
  def set
    expert_prediction = ExpertPrediction.find(params[:prediction_id])
    update_slider(params[:id], expert_prediction.year_values.select_year(Current.setting.end_year).first.value) if expert_prediction
  end
  
  def reset
    update_slider(params[:id], 0)
  end
  
  # page shown in ajax popup
  def index
    @slide = Slide.find(params[:slide_id])
    @output_element = OutputElement.find(64)
  end
  
  private
  
    def update_slider(slider_id,value)
      render :update do |page|
        slider_call = "App.inputElementsController.get(%s)" % slider_id
        page.call "#{slider_call}.setAttribute", "user_value", value.round(2)
        page.call "App.doUpdateRequest"
      end
    end
end
