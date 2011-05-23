class SavedScenario < ActiveRecord::Base
  belongs_to :user

  # We're dealing with an ActiveResource object, most ActiveRecord
  # automagic methods don't work.
  def scenario
    @scenario ||= Api::Scenario.find(scenario_id)
  end

  def scenario=(x)
    self.scenario_id = x.id unless x.nil?
  end
end
