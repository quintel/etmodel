class OutputElementsController < ApplicationController
  around_filter :disable_gc
  

  # layout 'fancybox'
  def show
    @output_element = OutputElement.find(params[:id])

    respond_to do |format|
      format.js { render }
    end
  end

  def change
    Current.current_slide = Slide.find(params[:slide]).name.underscore
    id = Current.scenario.selected_output_element || params[:id]
    render_chart(id)
  end

  def select  
  end

  def select_chart
    Current.scenario.selected_output_element = params[:id]
    render_chart(Current.scenario.selected_output_element)
  end
  
  def default_chart
    Current.scenario.selected_output_element = nil
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
