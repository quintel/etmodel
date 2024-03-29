# Create a report based on a .yml file in config/saved_scenario_reports
# The report name and format should be provided in params (only works for csv)
class SavedScenarioReportsController < ApplicationController
  before_action :assign_saved_scenario

  def show
    @queries = fetch_queries.or { return(render_not_found) }

    if valid_report_name?
      respond_to { |format| format.csv }
    else
      redirect_to @saved_scenario, notice: 'Your report could not be created'
    end
  end

  private

  def fetch_queries
    FetchAPIScenarioQueries.call(engine_client, @saved_scenario.scenario_id, queries)
  end

  def report_template
    template_path = "config/saved_scenario_reports/#{params[:report_name]}.yml"
    @report_template ||= YAML.load_file(template_path)
  end

  def queries
    @queries ||= report_template.values
                                .flat_map(&:values)
                                .flat_map(&:values)
  end

  def valid_report_name?
    Dir.glob(Rails.root.join('config/saved_scenario_reports/*.yml'))
       .any? { |fname| fname.ends_with? "#{params[:report_name]}.yml" }
  end

  def assign_saved_scenario
    @saved_scenario = SavedScenario.find(params[:saved_scenario_id])
  end
end
