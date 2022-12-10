# frozen_string_literal: true

# Creates a new API scenario with the given attributes. Scenarios are marked as
# read-only unless otherwise configured using the given attributes.
CreateApiScenario = lambda do |attributes = {}|
  attributes = attributes
    .slice(:area_code, :end_year, :scenario_id, :read_only)
    .reverse_merge(read_only: true, source: 'ETM')

  scenario = Engine::Scenario.create(scenario: { scenario: attributes })

  if scenario.errors.any?
    return ServiceResult.failure(scenario.errors.map(&:full_message))
  end

  return ServiceResult.success(scenario)
end
