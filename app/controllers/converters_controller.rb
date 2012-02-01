class ConvertersController < ApplicationController
  # GET /converters/:input_element_id
  # The page will load the converter details inside an iframe
  def show
    @input_element = InputElement.find(params[:input_element_id])
    @key = @input_element.related_converter
    @api_session_id = Current.setting.api_session_id rescue nil
  end
end
