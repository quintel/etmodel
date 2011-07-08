class OutputElementsController < ApplicationController
  def show
    @output_element = OutputElement.find(params[:id])

    if @output_element.html_table?
      @gquery_ids = @output_element.allowed_output_element_series.map(&:gquery)
    end

    respond_to do |format|
      format.js { render }
    end
  end

  def select  
  end

  def select_chart
    Current.setting.selected_output_element = params[:id]
    render_chart(Current.setting.selected_output_element)
  end
  
  def default_chart
    Current.setting.selected_output_element = nil
    render_chart(params[:id])
  end

  def render_chart(id)
    render :update do |page|
      unless (id == OutputElement::BLOCK_CHART_ID)
        page.call "window.charts.load", id
      end
    end
  end

  def invisible
    session[params[:id]] = 'invisible'
    render :update do |page|
    end
  end

  def visible
    session[params[:id]] = 'visible'
    render :update do |page|
    end
  end
end
