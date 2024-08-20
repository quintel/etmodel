# frozen_string_literal: true

module API
  # Allows users to save scenarios and have them appear in the application.
  class SavedScenariosController < APIController
    before_action :verify_token!

    before_action(only: %i[index show])    { verify_scopes!(%w[scenarios:read]) }
    before_action(only: %i[create update]) { verify_scopes!(%w[scenarios:read scenarios:write]) }
    before_action(only: %i[destroy])       { verify_scopes!(%w[scenarios:read scenarios:delete]) }

    def index
      @pagy, scenarios = pagy(
        current_user
          .saved_scenarios
          .order(created_at: :desc),
        page: (params[:page].presence || 1).to_i,
        items: (params[:limit].presence || 25).to_i.clamp(1, 100)
      )

      render json: PaginationSerializer.new(
        pagy: @pagy,
        collection: scenarios,
        serializer: ->(item) { item },
        url_for: ->(page, limit) { api_saved_scenarios_url(page: page, limit: limit) }
      )
    end

    def show
      render json: current_user.saved_scenarios.find(params.require(:id))
    end

    def create
      scenario = SavedScenario.new(scenario_params.merge(user: current_user))

      if scenario.save
        render json: scenario, status: :created
      else
        render json: scenario.errors, status: :unprocessable_entity
      end
    end

    def update
      scenario = current_user.saved_scenarios.find(params.require(:id))

      if scenario.update_with_api_params(scenario_params)
        render json: scenario, status: :ok
      else
        render json: scenario.errors, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.saved_scenarios.find(params.require(:id)).destroy
      head :ok
    end

    # NOPE --> check if old scenario id in update statement - then we restore!


    # ADD extra API for changing description of version

    private

    def scenario_params
      params.permit(:scenario_id, :title, :description, :area_code, :end_year, :private, :discarded)
    end
  end
end
