class TabController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser,
                :load_view_settings,
                :store_last_etm_page,
                :load_output_element,
                :load_constraints,
                :load_goals

  before_filter :show_intro_at_least_once, :only => :show

  def show
    render :template => 'tab/show'
  end

  protected

    def load_output_element
      @output_element = Current.view.default_output_element_for_sidebar_item
    end

    def show_intro_at_least_once
      redirect_to :action => 'intro' unless Current.already_shown?("#{params[:controller]}")
    end

    def load_constraints
      @constraints = Current.view.root.constraints.order(:id) rescue []
    end

    def load_goals
      @goals = PolicyGoal.allowed_policies
    end
end