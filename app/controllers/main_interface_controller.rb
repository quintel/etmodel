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
        before_action(:load_interface, :load_dashboard_items, only: action_names)
        layout('etm', only: action_names)
      end
    end
  end

  # Methods common to all controllers which use the main interface.
  module Common
    private

    def load_interface
      @interface = Interface.new(params[:tab], params[:sidebar], params[:slide])

      # If the params request a sidebar item or slide which isn't present,
      # redirect to the standard "play" URL so the user can continue their
      # scenario.
      redirect_to play_url, status: :moved_permanently unless @interface.valid?

      # The JS app will take care of fetching a scenario id, in the meanwhile
      # we use this variable to show all the items in the top menu
      @active_scenario = true
    end

    def load_dashboard_items
      @dashboard_items = DashboardItem.for_dashboard(session[:dashboard])
    end
  end
end # MainInterfaceController
