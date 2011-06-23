class TabController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser,
                :store_last_etm_page,
                :load_output_element,
                :fetch_api_session_id

  # included here, so that we don't mess with the before_filter order
  include ApplicationController::HasDashboard


  before_filter :show_intro_at_least_once, :only => :show

  def show
    @slides = Current.view.slides
    render :template => 'tab/show'
  end

  protected

    def load_output_element
      @output_element = Current.view.default_output_element_for_current_sidebar_item
    end

    def show_intro_at_least_once
      redirect_to :action => 'intro' unless Current.already_shown?("#{params[:controller]}")
    end
    
    def fetch_api_session_id      
      Current.setting.api_session_key ||= Api::Client.new.fetch_session_id
      # TODO: add graceful degradation if the request fails
    end
end