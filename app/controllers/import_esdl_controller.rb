# frozen_string_literal: true

# Only index and create. Calls a service that generates an ETE scenario based on the
# specified ESDL file. The service returns the scenario_id when (fully) succesful.
class ImportEsdlController < ApplicationController
  before_action :ensure_esdl_enabled
  before_action :store_location, only: :index

  def index
    return unless esdl_id

    tree_result = BrowseEsdlSuite.call(esdl_id)
    return unless tree_result.successful?

    @esdl_tree = tree_result.value
  end

  def create
    redirect_to import_esdl_path and return if esdl_file.blank?

    # TODO: Should set filename as scenario title?
    result = CreateEsdlScenario.call(esdl_file, @filename)

    if result.failure?
      redirect_to import_esdl_path, notice: result.errors.join(', ')
    else
      redirect_to load_scenario_path(id: result.value)
    end
  end

  private

  def ensure_esdl_enabled
    redirect_to(root_url) unless Settings.esdl_ete_url
  end

  def esdl_id
    @esdl_id ||= current_user&.esdl_suite_id
  end

  # TODO: This @filename stuff is very ugly
  def esdl_file
    @esdl_file ||=
      if params[:mondaine_drive_path].present?
        @filename = params[:mondaine_drive_path].split('/').last
        result = FetchFromEsdlSuite.call(esdl_id, params[:mondaine_drive_path])
        result.successful? ? result.value : ''
      elsif params[:esdl_file].present?
        @filename = params[:esdl_file].original_filename
        params[:esdl_file].read
      else
        ''
      end
  end
end
