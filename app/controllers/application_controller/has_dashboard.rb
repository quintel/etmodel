# Include all Methods that are needed when a controller contains the dashboard.
#
module ApplicationController::HasDashboard
  extend ActiveSupport::Concern

  included do
    before_filter :load_constraints
  end

  module InstanceMethods
    def load_constraints
      dash = session[:dashboard]

      @constraints = if dash and dash.any?
        Constraint.for_dashboard(dash)
      else
        Constraint.default.ordered
      end
    end
  end
end
