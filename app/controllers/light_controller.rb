class LightController < ApplicationController
  layout 'static_page'

  def index
    respond_to do |format|
      format.html
    end
  end
end

