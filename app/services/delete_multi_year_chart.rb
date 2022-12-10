# frozen_string_literal: true

# Removes a MultiYearChart from the database, along with all related scenarios,
# and instructs ETEngine that the scenarios no longer need to be protected.
#
# myc - A MultiYearChart record.
#
# Returns a ServiceResult.
DeleteMultiYearChart = lambda do |myc|
  scenario_ids = myc.scenarios.pluck(:scenario_id)

  myc.destroy
  scenario_ids.each { |id| SetAPIScenarioCompatibility.dont_keep_compatible(id) }

  ServiceResult.success
end
