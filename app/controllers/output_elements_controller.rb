class OutputElementsController < ApplicationController
  before_filter :find_output_element, :only => [:show, :select_chart, :default_chart]

  def show
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
    Current.setting.selected_output_element = @output_element.id
    render_chart(@output_element.id)
  end

  def default_chart
    Current.setting.selected_output_element = nil
    render_chart(@output_element.id)
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

  private

  def find_output_element
    @output_element = OutputElement.find(params[:id])
  end

  def render_chart(output_element)
    render :update do |page|
      page.call("window.charts.load", output_element.id) unless output_element.block_chart?
    end
  end
end
