# Create a report based on a .yml file in config/saved_scenario_reports
# The report name and format should be provided in params (only works for csv)
class SavedScenarioReportsController < ApplicationController
  before_action :ensure_valid_browser

  def show
    @scenario_id = SavedScenario.find(params[:saved_scenario_id]).scenario_id
    @yml = YAML.load_file("config/saved_scenario_reports/#{report_name}.yml")

    if valid_report_name? && valid_api_response?
      @query_api_response = api_response['gqueries']
      respond_to do |format|
        format.csv { render 'saved_scenarios/reports/show.csv.erb' }
      end
    else
      redirect_to saved_scenario_path(id: @scenario_id),
                  notice:  'Your report could not be created'
    end
  end

  def api_response
    @api_response ||= Api::Scenario.find_with_queries(@scenario_id, queries)
                                   .parsed_response
  end

  # yml file has queries on depth 3
  def queries
    @queries ||= @yml.flat_map do |_k, v|
      v.flat_map { |_k2, v2| v2.values }
    end
  end

  private
  def report_name
    params[:report_name].split('.')[0]
  end

  def valid_api_response?
    !api_response['errors'].present?
  end

  def valid_report_name?
    valid_report_names.include?(report_name)
  end

  def valid_report_names
    entries = Dir.entries('config/saved_scenario_reports').map do |file|
      file.sub(/\.+\w*/, '')
    end
    entries.reject(&:empty?)
  end
end
