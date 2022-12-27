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
        optional(:scenario_ids).filled(min_size?: 1, max_size?: 10).each(:integer, gt?: 0)
      end
    end

    def call(transition_path:, params:)
      params = yield validate(params)
      scenario_ids = params.delete(:scenario_ids)

      transition_path.attributes = params

      MultiYearChart.transaction do
        update_scenarios(transition_path, scenario_ids.uniq) if scenario_ids&.any?
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
  end
end
