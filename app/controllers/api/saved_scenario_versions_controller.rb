# frozen_string_literal: true

module API
  # Allows users to save scenario versions and have them appear in the application.
  class SavedScenarioVersionsController < APIController
    before_action :verify_token!

    before_action :find_saved_scenario
    before_action only: %i[show update destroy], :find_saved_scenario_version

    before_action { verify_scopes!(%w[scenario:write scenarios:delete]) }

    def index
      saved_scenario_versions = @saved_scenario
        .saved_scenario_versions
        .order(created_at: :desc)
        .page((params[:page].presence || 1).to_i)
        .per((params[:limit].presence || 25).to_i.clamp(1, 100))

      render json: PaginationSerializer.new(
        collection: saved_scenario_versions,
        serializer: ->(item) { item },
        url_for: ->(page, limit) { api_saved_scenario_versios_url(page:, limit:) }
      )
    end

    def show
      render json: @saved_scenario_version
    end

    def create
      saved_scenario_version = \
        SavedScenarioVersion.new(
          permitted_params.merge(
            user: current_user,
            saved_scenario: @saved_scenario
          )
        )

      if saved_scenario_version.save
        render json: saved_scenario_version, status: :created
      else
        render json: saved_scenario_version.errors, status: :unprocessable_entity
      end
    end

    # We only allow updating the message and the discarded flag for a SavedScenarioVersion.
    def update
      if @saved_scenario_version.update(message: permitted_params[:message], discarded: permitted_params[:discarded])
        render json: scenario, status: :ok
      else
        render json: scenario.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @saved_scenario_version.destroy

      head :ok
    end

    private

    def permitted_params
      params.permit(:saved_scenario_id, :id, :scenario_id, :message, :discarded)
    end

    def find_saved_scenario
      render json: [], status: :not_found and return unless current_user.present?

      @saved_scenario = current_user.saved_scenarios.find(:saved_scenario_id)

      render json: [], status: :not_found and return unless @saved_scenario.present?
    end

    def find_saved_scenario_version
      @saved_scenario_version = @saved_scenario.saved_scenario_versions.find(params.require(:id))

      render json: [], status: :not_found and return unless @saved_scenario_version.present?
    end
  end
end

