# frozen_string_literal: true

# Restores a saved scenario to an older version. Unprotects all discarded scenarios
class RestoreSavedScenario
  include Service

  def initialize(http_client, saved_scenario, scenario_id)
    @http_client = http_client
    @saved_scenario = saved_scenario
    @scenario_id = scenario_id
  end

  def call
    return ServiceResult.success(@saved_scenario) if @saved_scenario.scenario_id == @scenario_id

    unless discarded_versions
      return ServiceResult.failure("Version #{@scenario_id} could not be restored")
    end

    @saved_scenario.save!

    unprotect_discarded

    ServiceResult.success(@saved_scenario)
  end

  private

  def discarded_versions
    @discarded_versions ||= @saved_scenario.restore_version(@scenario_id)
  end

  def unprotect_discarded
    discarded_versions.each do |version_id|
      SetAPIScenarioCompatibility.dont_keep_compatible(@http_client, version_id)
    end
  end
end
