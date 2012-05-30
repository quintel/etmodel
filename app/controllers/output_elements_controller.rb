class OutputElementsController < ApplicationController
  layout false
  before_filter :default_format_js

  def show
    @output_element = OutputElement.find(params[:id])
    respond_to do |format|
      format.js { render }
    end
  end

  def index
  end

  # legacy actions used by the block charts
  #
  def invisible
    session[params[:id]] = 'invisible'
    render :js => ""
  end

  def visible
    session[params[:id]] = 'visible'
    render :js => ""
  end

  private

  # otherwise rails won't render the js.erb views
  def default_format_js
    request.format = "js" unless params[:format]
  end
end
