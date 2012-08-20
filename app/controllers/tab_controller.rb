class TabController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser,
                :store_last_etm_page,
                :load_interface, :only => :show

  # included here, so that we don't mess with the before_filter order
  include ApplicationController::HasDashboard

  def show
    respond_to do |format|
      format.html { render :template => 'tab/show'}
      format.js
    end
  end

  # popup with the text description
  def info
    # The title is stored in an object
    @title = Text.find_by_key("#{params[:ctrl]}_#{params[:act]}").try :title
    # The description belongs to a sidebar item. Ugly!
    s = SidebarItem.find_by_section_and_key(params[:ctrl], params[:act])
    @description = s.description.try(:content) if s
    render :layout => false
  end

  protected

    def load_interface
      tab_key = params[:tab]
      sidebar_key = params[:sidebar]

      @tabs = Tab.ordered
      @current_tab = Tab.find_by_key tab_key

      @sidebar_items = @current_tab.sidebar_items.ordered.includes(:area_dependency).reject(&:area_dependent)
      @current_sidebar_item = SidebarItem.find_by_key sidebar_key

      # check valid sidebar item
      if sidebar_key && !@sidebar_items.map(&:key).include?(sidebar_key)
        redirect_to '/targets' and return
      end

      @slides = @current_sidebar_item.slides.includes(:description).ordered
      @current_slide = @slides.first

      # Deal with the charts
      chart_settings = Current.setting.charts
      default_chart = @current_slide.output_element
      chart_settings[:chart_0][:default] = default_chart.id

      # make an array of the charts to show
      @charts = chart_settings.keys.map do |holder_id|
        chart_id = chart_settings[holder_id][:chart_id] || chart_settings[holder_id][:default]
        OutputElement.find_by_id(chart_id)
      end

      @targets = Target.includes(:area_dependency).reject(&:area_dependent)

      # The JS app will take care of fetching a scenario id, in the meanwhile we
      # use this variable to show all the items in the top menu
      @active_scenario = true
    end

    def store_last_etm_page
      Current.setting.last_etm_page = request.fullpath
    end
end
