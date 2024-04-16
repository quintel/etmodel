# frozen_string_literal: true

# Given a saved scenarios version tags, parses the version tags of the underlying
# scenarios and presents it as a json to be picked up by the front end
class SavedScenarioHistoryPresenter
  def self.present(saved_scenario, history)
    new(saved_scenario, history).as_json
  end

  def initialize(saved_scenario, history)
    # TODO: keys should be ints not strings!
    @history = history
    @scenario_ids_ordered = saved_scenario.version_scenario_ids
  end

  # Sorts the version tags in the history based on the ordering within the saved scenarios history
  # With the current scenario being the first, and the oldest scenario last
  def as_json(*)
    @scenario_ids_ordered.map{ |id| present(id) }
  end

  private

   # TODO: remove the to_s on the id
  def present(scenario_id)
    version = @history[scenario_id.to_s]

    version['user'] =
      if version.key?('user_id')
        User.find(version.delete('user_id').to_i).name
      else
        I18n.t('scenario.users.unknown')
      end

    version['scenario_id'] = scenario_id

    version
  end
end
