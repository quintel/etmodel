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

  serialize :scenario_id_history, Array

  def self.batch_load(saved_scenarios)
    ids    = saved_scenarios.map(&:scenario_id)
    loaded = Api::Scenario.batch_load(ids).index_by(&:id)

    saved_scenarios.each do |saved|
      saved.scenario = loaded[saved.id]
    end

    saved_scenarios
  end

  def scenario(detailed: false)
    begin
      if detailed
        @scenario ||= Api::Scenario.find(scenario_id, params: {detailed: true})
      else
        @scenario ||= Api::Scenario.find(scenario_id)
      end
    rescue ActiveResource::ResourceNotFound
      nil
    end
  end

  def scenario=(x)
    @scenario = x
    self.scenario_id = x.id unless x.nil?
  end

  def build_setting(user: nil)
    if user && (user.id == self.user_id)
      Setting.load_from_scenario(scenario, active_saved_scenario_id: id)
    else
      Setting.load_from_scenario(scenario)
    end
  end
end
