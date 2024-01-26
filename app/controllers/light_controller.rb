class LightController < ApplicationController
  layout 'light'

  def index
    respond_to do |format|
      format.html
    end
  end

end

