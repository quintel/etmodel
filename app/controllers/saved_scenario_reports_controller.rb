class SavedScenarioReportsController < ApplicationController
  before_action :ensure_valid_browser
  before_action :assign_scenario
  before_action :assign_report_name, only: :show

  def show
    @yml = YAML.load_file(yml_report_path)
    run_queries
    respond_to do |format|
      format.csv { render "saved_scenarios/reports/show.csv.erb", content_type: 'text/csv' }
    end
  end

  def run_queries
    @queries = []
    find_queries(@yml)
    #doet het niet! huilen
    # @response = Api::Scenario.find_with_queries(@scenario.id, @queries)
  end

  def find_queries(yml_part)
    if yml_part.is_a?(Hash)
      yml_part.values.each do |yml_sub_part|
        find_queries(yml_sub_part)
      end
    else
      #can be nil because not all queries are specified yet by mart
      @queries << yml_part if yml_part
    end
  end

  private
  def assign_report_name
    @report_name = params[:report_name].split('.')[0]
    unless Pathname.new(yml_report_path).expand_path.exist?
      redirect_to saved_scenario_path(id: params[:saved_scenario_id])
    end
  end

  def yml_report_path
    "config/saved_scenario_reports/#{ @report_name }.yml"
  end

  # copied from saved_scenario -> maybe make more available?
  def assign_scenario
    @saved_scenario = SavedScenario.find(params[:saved_scenario_id])
    @scenario = @saved_scenario.scenario(detailed: true)

    unless @scenario&.loadable?
      redirect_to root_path, notice: 'Sorry, this scenario cannot be loaded'
    end
  rescue ActiveResource::ResourceNotFound
    redirect_to root_path, notice: 'Scenario not found'
  end

end