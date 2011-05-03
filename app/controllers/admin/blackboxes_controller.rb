class Admin::BlackboxesController  < Admin::AdminController
  def index
    @blackboxes = Blackbox.ordered
  end

  def show
    find_model
  end

  def rspec
    find_model
  end

  def new
    @blackbox = Blackbox.new
  end

  def create
    Current.scenario.end_year = 2040
    Current.scenario.update_statements = {}

    @blackbox = Blackbox.new(params[:blackbox])
    if @blackbox.save
      flash[:notice] = "Blackbox created"
      redirect_to admin_blackboxes_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @blackbox = Blackbox.find(params[:id])
    if @blackbox.destroy
      flash[:notice] = "Blackbox #{@blackbox.name} deleted"
      redirect_to admin_blackboxes_url
    else
      flash[:error] = "Blackbox #{@blackbox.name} not deleted"
      redirect_to admin_blackboxes_url
    end
  end

  private

  def find_model
    if params[:graph_id]
      Current.graph_id = params[:graph_id]
    end
    @blackbox = Blackbox.find(params[:id])
    @blackbox_scenarios = BlackboxScenario.all
    @blackbox_output_series = @blackbox.blackbox_output_serie.includes(:output_element_serie)
    @blackbox_gqueries = @blackbox.blackbox_gqueries.includes(:gquery)
  end
end
