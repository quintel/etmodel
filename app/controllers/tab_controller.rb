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
      @interface = Interface.new(params[:tab], params[:sidebar])

      # Deal with the charts
      chart_settings = Current.setting.charts
      chart_settings['chart_0']['default'] = @interface.default_chart.id

      # make an array of the charts to show
      @charts = chart_settings.keys.map do |holder_id|
        chart_id = chart_settings[holder_id]['chart_id'] ||
          chart_settings[holder_id]['default']
        OutputElement.find_by_id(chart_id)
      end

      # The JS app will take care of fetching a scenario id, in the meanwhile we
      # use this variable to show all the items in the top menu
      @active_scenario = true
    end

    def store_last_etm_page
      Current.setting.last_etm_page = request.fullpath
    end
end
