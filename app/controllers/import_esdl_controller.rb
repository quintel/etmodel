# frozen_string_literal: true

# Only index and create. Calls a service that generates an ETE scenario based on the
# specified ESDL file. The service returns the scenario_id when (fully) succesful.
class ImportEsdlController < ApplicationController
  before_action :ensure_esdl_enabled

  def index
    esdl_id = current_user&.esdl_suite_id
    return unless esdl_id

    tree_result = EsdlSuiteService.setup.get_tree(esdl_id, 'aaa')
    return unless tree_result.successful?

    @esdl_tree = tree_result.value
  end

  def create
    result = CreateEsdlScenario.call(params[:esdl_file])

    if result.failure?
      redirect_to import_esdl_path, notice: result.errors.join(', ')
    else
      redirect_to load_scenario_path(id: result.value['scenario_id'])
    end
  end

  def browse_mondaine_drive
    respond_to do |format|
      format.js
    end
  end

  private

  def ensure_esdl_enabled
    redirect_to(root_url) unless APP_CONFIG[:esdl_api_url]
  end
end
