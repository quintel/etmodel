# Include all Methods that are needed when a controller contains the dashboard.
#
module ApplicationController::HasDashboard
  extend ActiveSupport::Concern

  included do
    before_filter :load_constraints, :load_goals
  end

  module InstanceMethods
    def load_constraints
      @constraints = Current.view.constraints
    end

    def load_goals
      @goals = Current.view.policy_goals
    end
  end
end