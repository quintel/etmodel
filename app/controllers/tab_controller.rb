class TabController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser,
                :store_last_etm_page,
                :load_interface, :only => :show

  before_filter :track_user, :if => lambda{ APP_CONFIG[:wattnu] || session[:wattnu] }

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
      tab_key = params[:controller]
      sidebar_key = params[:id]

      @tabs = Tab.ordered
      @current_tab = Tab.find_by_key tab_key

      @sidebar_items = @current_tab.sidebar_items.reject(&:area_dependent)
      @current_sidebar_item = SidebarItem.find_by_key sidebar_key

      # check valid sidebar item
      if sidebar_key && !@sidebar_items.map(&:key).include?(sidebar_key)
        redirect_to :action => 'intro' and return
      end

      @slides = @current_sidebar_item.slides.ordered
      @current_slide = @slides.first

      @title = Text.find_by_key("#{tab_key}_#{sidebar_key}").try :title

      @output_element = if Current.setting.main_chart
        OutputElement.find Current.setting.main_chart
      else
        @current_slide.output_element
      end

      if other = Current.setting.secondary_chart
        @secondary_output_element = OutputElement.find(other)
      end

      @targets = Target.all.reject(&:area_dependent)
    end

    def track_user
      controller = I18n.t(params[:controller].capitalize) rescue nil
      sidebar = I18n.t('sidebar_items.' + params[:id]) rescue nil
      Tracker.instance.track({:tab => controller, :sidebar => sidebar}, current_user)
    end
end
