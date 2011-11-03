# Include all Methods that are needed when a controller contains the dashboard.
#
module ApplicationController::HasDashboard
  extend ActiveSupport::Concern

  included do
    before_filter :load_constraints, :load_goals
  end

  module InstanceMethods
    def load_constraints
      dash = session[:dashboard]

      @constraints = if dash and dash.any?
        Constraint.for_dashboard(dash)
      else
        Current.view.constraints
      end
    end

    def load_goals
      @goals = Current.view.policy_goals
    end
  end
end
