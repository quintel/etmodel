class ExpertPredictionsController < ApplicationController
  
  ## This method is called by ajax. It updates the given slider with the value from the db
  def set
    expert_prediction = ExpertPrediction.find(params[:prediction_id])
    if expert_prediction
      new_value = expert_prediction.year_values.select_year(Current.setting.end_year).first.value
      update_slider(params[:slider_id], new_value)
    end
  end
  
  def reset
    update_slider(params[:slider_id], 0)
  end
  
  # page shown in ajax popup
  def index
    @slide = Slide.find(params[:slide_id])
    @output_element = OutputElement.find(64)
  end
  
  private
  
    def update_slider(slider_id,value)
      render :update do |page|
        page << "input_elements.get(#{slider_id}).set({user_value: #{value}})"
        page.call "App.doUpdateRequest"
      end
    end
end
