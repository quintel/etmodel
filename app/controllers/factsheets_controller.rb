class FactsheetsController < ApplicationController
  layout 'factsheet'

  def show
    @scenario = Api::Scenario.find(params[:id])
    @saved_scenario = SavedScenario.find_by(scenario_id: @scenario.id)
  rescue ActiveResource::ResourceNotFound
    # No such scenario.
    render_not_found('scenario')
  end
end
