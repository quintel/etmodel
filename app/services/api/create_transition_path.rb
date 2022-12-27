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
        required(:scenario_ids).filled(min_size?: 1, max_size?: 10).each(:integer, gt?: 0)
      end
    end

    def call(user:, params:)
      params = yield validate(params)
      scenario_ids = params.delete(:scenario_ids)

      transition_path = user.multi_year_charts.build(params)

      scenario_ids.uniq.each do |scenario_id|
        transition_path.scenarios.build(scenario_id:)
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
