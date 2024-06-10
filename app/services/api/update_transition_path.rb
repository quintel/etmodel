# frozen_string_literal: true

module API
  # Creates a transition path from an API request.
  class UpdateTransitionPath
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    class Contract < Dry::Validation::Contract
      json do
        optional(:title).filled(:string)
        optional(:area_code).filled(:string)
        optional(:end_year).filled(:integer)
        optional(:scenario_ids).filled(min_size?: 1, max_size?: 100).each(:integer, gt?: 0)
        optional(:saved_scenario_ids).filled(min_size?: 1, max_size?: 100).each(:integer, gt?: 0)
      end
    end

    def call(transition_path:, params:)
      params = yield validate(params)
      scenario_ids = params.delete(:scenario_ids)
      saved_scenario_ids = params.delete(:saved_scenario_ids)

      transition_path.attributes = params

      MultiYearChart.transaction do
        update_scenarios(transition_path, scenario_ids.uniq) if scenario_ids&.any?
        update_saved_scenarios(transition_path, saved_scenario_ids.uniq) if saved_scenario_ids&.any?
        transition_path.save!
      rescue ActiveRecord::RecordInvalid
        return Failure(transition_path.errors)
      end

      Success(transition_path.reload)
    end

    private

    def validate(params)
      result = Contract.new.call(params)
      result.success? ? Success(result.to_h) : Failure(result.errors.to_h)
    end

    def update_scenarios(transition_path, scenario_ids)
      existing_ids = transition_path.scenarios.pluck(:scenario_id)
      new_ids      = scenario_ids - existing_ids
      delete_ids   = existing_ids - scenario_ids

      transition_path.scenarios.delete_by(scenario_id: delete_ids)
      new_ids.each { |id| transition_path.scenarios.create!({ scenario_id: id }) }
    end

    def update_saved_scenarios(transition_path, saved_scenario_ids)
      existing_ids = transition_path.saved_scenarios.pluck(:saved_scenario_id)
      new_ids      = saved_scenario_ids - existing_ids
      delete_ids   = existing_ids - saved_scenario_ids

      transition_path.multi_year_chart_saved_scenarios.delete_by(saved_scenario_id: delete_ids)
      new_ids.each { |id| transition_path.multi_year_chart_saved_scenarios.create!({ saved_scenario_id: id }) }
    end
  end
end
