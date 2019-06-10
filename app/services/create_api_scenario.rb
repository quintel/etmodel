# frozen_string_literal: true

# Creates a new API scenario with the given attributes. Scenarios are marked as
# protected.
CreateAPIScenario = lambda do |attributes = {}|
  attributes = attributes
    .slice(:area_code, :description, :end_year, :scenario_id, :title)
    .merge(protected: true, source: 'ETM')

  scenario = Api::Scenario.create(scenario: { scenario: attributes })

  if scenario.errors.any?
    return ServiceResult.failure(scenario.errors.full_messages)
  end

  return ServiceResult.success(scenario)
end
