# frozen_string_literal: true

# we can add all the csv stuff here as well (?) can only do this if the scenario was saved??
class ExportScenarioController < ApplicationController
  before_action :set_scenario
  before_action :ensure_export_enabled

  def index; end

  def esdl
    result = ExportEsdlScenario.call(@scenario.id)

    if result.successful?
      send_data(result.value, filename: "etm_scenario_#{@scenario.id}.esdl")
      # or to M-Drive - need another service for that: UploadToEsdlSuite
    else
      redirect_to export_scenario_path, notice: result.errors.join(', ')
    end
  end

  private

  def set_scenario
    @scenario ||= Api::Scenario.find(params[:id])
  rescue ActiveResource::ResourceNotFound
    render_not_found('scenario')
  end

  def ensure_export_enabled
    render_not_found unless @scenario.esdl_exportable
  end
end
