class InputElementsController < ApplicationController

  def show
    @input_element = InputElement.find(params[:id])
    respond_to do |format|
      format.html { render 'input_elements/slider' }
      format.json { render :json => input_element_json }
    end
  end

  def update
    @input_element = InputElement.find(params[:id])
    respond_to do |format|
      @input_element.reset if params[:reset]
      format.json { render :json => input_element_json }
    end
  end

  def input_element_json(input_element = @input_element)
    input_element.to_json(:only => [
      :id,
      :user_value,
      :start_value,
      :min_value,
      :max_value,
      :step_value,
      :input_element_type
    ])
  end

end
