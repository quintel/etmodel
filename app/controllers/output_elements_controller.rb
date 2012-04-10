class OutputElementsController < ApplicationController
  layout false
  before_filter :find_output_element, :only => [:show, :select_chart, :default_chart]
  before_filter :default_format_js, :only => [:default_chart, :select_chart]

  def show
    respond_to do |format|
      format.js { render }
    end
  end

  def select
  end

  def select_chart
    Current.setting.selected_output_element = @output_element.id
    render 'load'
  end

  def default_chart
    Current.setting.selected_output_element = nil
    render 'load'
  end

  def invisible
    session[params[:id]] = 'invisible'
    render :js => ""
  end

  def visible
    session[params[:id]] = 'visible'
    render :js => ""
  end

  private

  def find_output_element
    @output_element = OutputElement.find(params[:id])
  end

  # otherwise rails won't render the js.erb views
  def default_format_js
    request.format = "js" unless params[:format]
  end
end
