# frozen_string_literal: true

module API
  # Allows users to save scenario versions and have them appear in the application.
  class SavedScenarioVersionsController < APIController
    before_action :verify_token!

    # Scenario collaborators and owners have the write scope and may manage saved scenario versions.
    before_action { verify_scopes!(%w[scenarios:write]) }

    before_action :find_saved_scenario
    before_action :find_saved_scenario_version, only: %i[show update revert]

    def index
      saved_scenario_versions = @saved_scenario
        .saved_scenario_versions
        .order(created_at: :asc)
        .page((params[:page].presence || 1).to_i)
        .per((params[:limit].presence || 25).to_i.clamp(1, 100))

      render json: PaginationSerializer.new(
        collection: saved_scenario_versions,
        serializer: ->(item) { item },
        url_for: ->(page, limit) { api_saved_scenario_versions_url(page:, limit:) }
      )
    end

    def show
      render json: @saved_scenario_version
    end

    def create
      @saved_scenario_version = \
        SavedScenarioVersion.new(
          permitted_params.merge(
            user: current_user,
            saved_scenario: @saved_scenario
          )
        )

      if @saved_scenario_version.save
        render json: @saved_scenario_version, status: :created
      else
        render json: @saved_scenario_version.errors, status: :unprocessable_entity
      end
    end

    # We only allow updating the message for a SavedScenarioVersion.
    def update
      if @saved_scenario_version.update(message: permitted_params[:message])
        render json: @saved_scenario_version, status: :ok
      else
        render json: @saved_scenario_version, status: :unprocessable_entity
      end
    end

    def revert
      @saved_scenario.set_version_as_current(@saved_scenario_version, revert: true)

      render json: [], status: :ok
    end

    private

    def permitted_params
      params.permit(:saved_scenario_id, :id, :scenario_id, :message)
    end

    def find_saved_scenario
      render json: [], status: :not_found and return unless current_user.present?

      @saved_scenario = current_user.saved_scenarios.find(permitted_params[:saved_scenario_id])

      render json: [], status: :not_found and return unless @saved_scenario.present?
    end

    def find_saved_scenario_version
      @saved_scenario_version = @saved_scenario.saved_scenario_versions.find(permitted_params[:id])

      render json: [], status: :not_found and return unless @saved_scenario_version.present?
    end
  end
end
