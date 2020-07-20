# frozen_string_literal: true

# Controller for Over Morgens fabulous Energy Mix infographic
class EnergyMixController < ApplicationController
  layout 'energy_mix'

  def show
    @scenario = Api::Scenario.find(params[:id])
    @saved_scenario = SavedScenario.find_by(scenario_id: @scenario.id)
  rescue ActiveResource::ResourceNotFound
    # No such scenario.
    render_not_found('scenario')
  end
end
