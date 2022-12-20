# frozen_string_literal: true

# Controller for Over Morgens fabulous Energy Mix infographic
class EnergyMixController < ApplicationController
  layout 'energy_mix'

  def show
    @scenario = FetchAPIScenario.call(engine_client, params[:id]).or do
      return render_not_found
    end

    @saved_scenario = SavedScenario.find_by(scenario_id: @scenario.id)
  rescue ActiveResource::ResourceNotFound
    # No such scenario.
    render_not_found('scenario')
  end
end
