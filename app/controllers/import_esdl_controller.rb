# frozen_string_literal: true

# Only index and create. Calls a service that generates an ETE scenario based on the
# specified ESDL file. The service returns the scenario_id when (fully) succesful.
class ImportEsdlController < ApplicationController
  before_action :ensure_esdl_enabled

  # layout 'landing'

  # what if user is already logged in?
  def index; end

  def create
    result = CreateEsdlScenario.call(params[:esdl_file])

    if result.failure?
      redirect_to import_esdl_path, notice: result.errors.join(', ')
    else
      redirect_to load_scenario_path(id: result.value['scenario_id'])
    end
  end

  def browse_mondaine_drive
    # result = MondaineDriveService.get_access_token(username, password)
    # return unless result.success?

    respond_to do |format|
      format.js
    end
  end

  private

  def ensure_esdl_enabled
    redirect_to(root_url) unless APP_CONFIG[:esdl_api_url]
  end
end
