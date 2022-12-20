# frozen_string_literal: true

# we can add all the csv stuff here as well (?) can only do this if the scenario was saved??
class ExportScenarioController < ApplicationController
  before_action :set_scenario
  before_action :ensure_export_enabled
  before_action :store_location, only: :index

  def index; end

  def esdl
    result = ExportEsdlScenario.call(@scenario.id)

    if result.successful?
      # Direct download
      unless mondaine_drive_upload_path && esdl_id
        send_data(result.value, filename: "etm_scenario_#{@scenario.id}.esdl")
        return
      end

      # Upload to Mondaine Drive
      upload_result = UploadToEsdlSuite.call(esdl_id, mondaine_drive_upload_path, result.value)
      if upload_result.successful?
        redirect_to export_scenario_path, notice: t('export.esdl.success')
      else
        redirect_to export_scenario_path, notice: upload_result.errors.join(', ')
      end
    else
      redirect_to export_scenario_path, notice: result.errors.join(', ')
    end
  end

  def mondaine_drive
    @esdl_tree = mondaine_drive_browse_tree

    respond_to do |format|
      format.js
    end
  end

  private

  def set_scenario
    @scenario ||= FetchAPIScenario.call(engine_client, params[:id]).unwrap
  rescue ActiveResource::ResourceNotFound
    render_not_found('scenario')
  end

  def ensure_export_enabled
    render_not_found unless @scenario.esdl_exportable
  end

  def mondaine_drive_browse_tree
    return unless esdl_id

    tree_result = BrowseEsdlSuite.call(esdl_id)
    return unless tree_result.successful?

    tree_result.value
  end

  def mondaine_drive_upload_path
    return unless params[:mondaine_drive_path] && params[:filename]
    return params[:mondaine_drive_path][1..] if params[:mondaine_drive_path].end_with?('.esdl')

    path = params[:mondaine_drive_path][1..] + '/' + params[:filename]
    path.end_with?('.esdl') ? path : path + '.esdl'
  end

  def esdl_id
    @esdl_id ||= current_user&.esdl_suite_id
  end
end
