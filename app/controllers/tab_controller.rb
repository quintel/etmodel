class TabController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser,
                :store_last_etm_page,
                :load_output_element

  before_filter :track_user, :if => lambda{ APP_CONFIG[:wattnu] || session[:wattnu] }

  # included here, so that we don't mess with the before_filter order
  include ApplicationController::HasDashboard

  before_filter :check_valid_sidebar_item, :only => :show

  def show
    @active_sidebar = Current.view.sidebar
    @slides = Current.view.slides

    respond_to do |format|
      format.html { render :template => 'tab/show'}
      format.js
    end
  end

  protected

    def load_output_element
      @output_element = if Current.setting.main_chart
        OutputElement.find Current.setting.main_chart
      else
        Current.view.default_chart
      end
      @secondary_output_element = if Current.setting.secondary_chart
        OutputElement.find Current.setting.secondary_chart
      else
        OutputElement.last()
      end
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
