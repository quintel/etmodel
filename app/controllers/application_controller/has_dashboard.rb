# Include all Methods that are needed when a controller contains the dashboard.
#
module ApplicationController::HasDashboard
  extend ActiveSupport::Concern

  included do
    before_filter :load_constraints, :load_goals
  end

  module InstanceMethods
    def load_constraints
      @constraints = if session[:dashboard].any?
        Constraint.for_dashboard(session[:dashboard])
      else
        Current.view.constraints
      end
    end

    def load_goals
      @goals = Current.view.policy_goals
    end
  end
end
