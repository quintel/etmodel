# frozen_string_literal: true

module API
  # Allows users to save scenarios and have them appear in the application.
  class SavedScenariosController < APIController
    before_action :verify_token!

    before_action(only: %i[index show])    { verify_scopes!(%w[scenarios:read]) }
    before_action(only: %i[create update]) { verify_scopes!(%w[scenarios:read scenarios:write]) }
    before_action(only: %i[destroy])       { verify_scopes!(%w[scenarios:read scenarios:delete]) }

    def index
      scenarios = current_user
        .saved_scenarios
        .order(created_at: :desc)
        .page((params[:page].presence || 1).to_i)
        .per((params[:limit].presence || 25).to_i.clamp(1, 100))

      render json: PaginationSerializer.new(
        collection: scenarios,
        serializer: ->(item) { item },
        url_for: ->(page, limit) { api_saved_scenarios_url(page:, limit:) }
      )
    end

    def show
      render json: current_user.saved_scenarios.find(params.require(:id))
    end

    def create
      scenario = SavedScenario.new(scenario_params.merge(user: current_user))

      if scenario.save
        scenario.create_new_version(current_user)

        render json: scenario, status: :created
      else
        render json: scenario.errors, status: :unprocessable_entity
      end
    end

    def update
      scenario = current_user.saved_scenarios.find(params.require(:id))

      if scenario.update_with_api_params(scenario_params, current_user)
        render json: scenario, status: :ok
      else
        render json: scenario.errors, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.saved_scenarios.find(params.require(:id)).destroy
      head :ok
    end

    private

    def scenario_params
      params.permit(:scenario_id, :title, :description, :area_code, :end_year, :private, :discarded)
    end
  end
end
