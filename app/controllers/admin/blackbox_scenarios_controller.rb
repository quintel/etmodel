class Admin::BlackboxScenariosController  < Admin::AdminController


  def index
    @blackbox_scenarios = BlackboxScenario.all
  end

  def show
    @blackbox_scenario = BlackboxScenario.find(params[:id])
  end

  def new
    @blackbox_scenario = BlackboxScenario.new
  end

  def create
    @blackbox_scenario = BlackboxScenario.new(params[:blackbox_scenario])
    if @blackbox_scenario.save
      flash[:notice] = "Blackbox Scenario created"
      redirect_to admin_blackbox_scenarios_url
    else
      render :action => 'new'
    end
  end
end
