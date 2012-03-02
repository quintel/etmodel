class TabController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser,
                :store_last_etm_page,
                :load_output_element,
                :fetch_api_session_id

  before_filter :track_user, :if => lambda{ APP_CONFIG[:wattnu] || session[:wattnu] }

  # included here, so that we don't mess with the before_filter order
  include ApplicationController::HasDashboard

  before_filter :check_valid_sidebar_item, :only => :show

  def show
    @active_sidebar = Current.view.sidebar_items.select{|item| params[:id] == item.key}.first
    @slides = Current.view.slides

    Current.setting.selected_output_element = nil
    Current.setting.displayed_output_element = @output_element.id if @output_element

    render :template => 'tab/show'
  end

  protected

    def load_output_element
      @output_element = Current.view.default_output_element_for_current_sidebar_item
    end

    def fetch_api_session_id
      Current.setting.api_session_id ||= Api::Client.new.fetch_session_id
      # TODO: add graceful degradation if the request fails
    end

    # Some sidebar items are area dependent. Let's redirect the user who crafted an invalid URL
    def check_valid_sidebar_item
      allowed = Current.view.sidebar_items.map(&:key)
      if params[:id] && !allowed.include?(params[:id])
        redirect_to :action => 'intro' and return
      end
    end

    def track_user
      controller = I18n.t(params[:controller].capitalize) rescue nil
      sidebar = I18n.t('sidebar_items.' + params[:id]) rescue nil
      Tracker.instance.track({:tab => controller, :sidebar => sidebar}, current_user)
    end
end
