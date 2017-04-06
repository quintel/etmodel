# == Schema Information
#
# Table name: saved_scenarios
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  scenario_id :integer          not null
#  settings    :text
#  created_at  :datetime
#  updated_at  :datetime
#

class SavedScenario < ActiveRecord::Base
  belongs_to :user

  attr_accessor :title, :description, :api_session_id

  validates :user_id,     presence: true
  validates :scenario_id, presence: true
  validates :title,       presence: true

  def self.batch_load(saved_scenarios)
    ids       = saved_scenarios.map(&:scenario_id)
    scenarios = Api::Scenario.batch_load(ids)

    saved_scenarios.length.times do |idx|
      saved_scenarios[idx].scenario = scenarios[idx]
    end
  end

  def scenario
    begin
      @scenario ||= Api::Scenario.find(scenario_id)
    rescue ActiveResource::ResourceNotFound
      nil
    end
  end

  def scenario=(x)
    @scenario = x
    self.scenario_id = x.id unless x.nil?
  end

end
