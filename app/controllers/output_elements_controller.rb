class OutputElementsController < ApplicationController
  layout false

  # Returns all the data required to show a chart.
  # JSON only
  def show
    chart = OutputElement.find(params[:id])
    template = if tmpl = chart.template
      render_to_string(:partial => tmpl, :locals => {:output_element => chart})
    else
     nil
   end
    render :status => :ok, :json => {
      :attributes => chart.options_for_js,
      :series => chart.allowed_output_element_series.map(&:options_for_js),
      :html => template
    }
  end

  def index
    # id of the element the chart will be placed in
    @chart_holder = params[:holder]
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
end
