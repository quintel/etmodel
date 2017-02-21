class OutputElementsController < ApplicationController
  layout false

  before_action :find_output_element, :only => [:show, :zoom]

  # Returns all the data required to show a chart.
  # JSON only
  def show
    template = if tmpl = @chart.template
      render_to_string(:partial => tmpl, :locals => {:output_element => @chart})
    else
     nil
   end
    render :status => :ok, :json => {
      :attributes => @chart.json_attributes,
      :series => @chart.allowed_output_element_series.map(&:json_attributes),
      :html => template
    }
  end

  def index
    # id of the element the chart will be placed in
    @chart_holder = params[:holder]
    @groups = OutputElement.not_hidden.select_by_group
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

  def zoom
  end

  private

  def find_output_element
    @as_table = params[:format] == 'table'
    @chart = OutputElement.find(params[:id])
  end
end
