# == Schema Information
#
# Table name: saved_scenarios
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  scenario_id :integer(4)      not null
#  settings    :text
#  created_at  :datetime
#  updated_at  :datetime
#

class SavedScenario < ActiveRecord::Base
  belongs_to :user

  attr_accessor :title, :description, :api_session_id

  validates :user_id,     :presence => true
  validates :scenario_id, :presence => true
  validates :title,       :presence => true

  def scenario
    @scenario ||= Api::Scenario.find(scenario_id)
  end

  def scenario=(x)
    self.scenario_id = x.id unless x.nil?
  end
end
