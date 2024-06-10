# frozen_string_literal: true

module API
  # Creates a transition path from an API request.
  class CreateTransitionPath
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    class Contract < Dry::Validation::Contract
      json do
        required(:title).filled(:string)
        required(:area_code).filled(:string)
        required(:end_year).filled(:integer)
        optional(:scenario_ids).filled(min_size?: 1, max_size?: 100).each(:integer, gt?: 0)
        optional(:saved_scenario_ids).filled(min_size?: 1, max_size?: 100).each(:integer, gt?: 0)
      end

      rule(:scenario_ids, :saved_scenario_ids) do
        if values[:scenario_ids].nil? && values[:saved_scenario_ids].nil?
          key.failure('at least one scenario_id or saved_scenario_id should be present')
        end
      end
    end

    def call(user:, params:)
      params = yield validate(params)
      scenario_ids = params.delete(:scenario_ids)
      saved_scenario_ids = params.delete(:saved_scenario_ids)

      transition_path = user.multi_year_charts.build(params)

      scenario_ids&.uniq&.each do |scenario_id|
        transition_path.scenarios.build(scenario_id:)
      end

      saved_scenario_ids&.uniq&.each do |saved_scenario_id|
        transition_path.multi_year_chart_saved_scenarios.build(saved_scenario_id:)
      end

      if transition_path.save
        Success(transition_path)
      else
        Failure(transition_path.errors)
      end
    end

    private

    def validate(params)
      result = Contract.new.call(params)
      result.success? ? Success(result.to_h) : Failure(result.errors.to_h)
    end
  end
end
