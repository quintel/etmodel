# frozen_string_literal: true

module API
  # Allows users to save scenarios and have them appear in the application.
  class SavedScenariosController < APIController
    before_action :verify_token!

    before_action(only: %i[index show])    { verify_scopes!(%w[scenarios:read]) }
    before_action(only: %i[create update]) { verify_scopes!(%w[scenarios:read scenarios:write]) }
    before_action(only: %i[destroy])       { verify_scopes!(%w[scenarios:read scenarios:delete]) }

    def index
      render json: current_user.saved_scenarios.order(:id)
    end

    def show
      render json: current_user.saved_scenarios.find(params.require(:id))
    end

    def create
      scenario = current_user.saved_scenarios.build(scenario_params)

      if scenario.save
        render json: scenario, status: :created
      else
        render json: scenario.errors, status: :unprocessable_entity
      end
    end

    def update
      scenario = current_user.saved_scenarios.find(params.require(:id))

      scenario.add_id_to_history(scenario.scenario_id)
      scenario.attributes = scenario_params

      if scenario.save
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
      params.require(:saved_scenario).permit(
        :scenario_id, :title, :description, :area_code, :end_year
      )
    end
  end
end
