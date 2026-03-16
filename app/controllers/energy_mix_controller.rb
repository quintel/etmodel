# frozen_string_literal: true

# Controller for Over Morgens fabulous Energy Mix infographic
class EnergyMixController < ApplicationController
  def show
    scenario = FetchAPIScenario.call(engine_client, params[:id]).or do
      return render_not_found
    end

    # Load the scenario into the session so the report page can query it.
    Current.setting = Setting.load_from_scenario(scenario)
    Current.setting.api_session_id = scenario.id

    redirect_to report_path('main')

  rescue ActiveResource::ResourceNotFound
    # No such scenario.
    render_not_found('scenario')
  end
end
