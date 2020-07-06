# frozen_string_literal: true

# Only index and create. Calls a service that generates an ETE scenario based on the
# specified ESDL file. The service returns the scenario_id when (fully) succesful.
class ImportEsdlController < ApplicationController
  def create
    result = CreateEsdlScenario.call(params[:esdl_file])

    if result.failure?
      redirect_to import_esdl_path, notice: result.errors.join(', ')
    else
      redirect_to load_scenario_path(id: result.value['scenario_id'])
    end
  end
end
