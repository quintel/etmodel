class Embeds::PicosController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false
  # Generates an embedable iframe in javascript format and a PICO map
  # as html.
  def show
    respond_to do |format|
      format.js
      format.html do
        @region_type = 'gemeente'
        @region_name = "Rotterdam"
        @pico_module = params[:pico_module]
      end
    end
  end
end
