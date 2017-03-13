# Helper module which sets up the 'etm' layout.
module MainInterfaceController
  module_function

  # Returns a module which may be included into a controller which will set up
  # the necessary variables to show the page with the main 'etm' layout. Provide
  # to `new` a list of actions which will use the layout.
  def new(*action_names)
    Module.new do
      extend ActiveSupport::Concern
      include Common

      included do
        before_action(:load_interface, :load_constraints, only: action_names)
        layout('etm', only: action_names)
      end
    end
  end

  # Methods common to all controllers which use the main interface.
  module Common
    private

    def load_interface
      tab = params[:tab] || 'demand'
      @interface = Interface.new(tab, params[:sidebar], params[:slide])

      # The JS app will take care of fetching a scenario id, in the meanwhile
      # we use this variable to show all the items in the top menu
      @active_scenario = true
    end

    def load_constraints
      @constraints = Constraint.for_dashboard(session[:dashboard])
    end
  end
end # MainInterfaceController
