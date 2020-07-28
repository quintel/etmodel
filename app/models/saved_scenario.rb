# == Schema Information
#
# Table name: saved_scenarios
#
#  id                  :integer          not null, primary key
#  user_id             :integer          not null
#  scenario_id         :integer          not null
#  scenario_id_history :string
#  title               :string           not null
#  description         :string
#  area_code           :string           not null
#  end_year            :integer          not null
#  settings            :text
#  created_at          :datetime
#  updated_at          :datetime
#

# A scenario saved by a user for safe-keeping.
#
# Contains a record of all the scenario IDs for previous versions of the scenario.
class SavedScenario < ApplicationRecord
  belongs_to :user
  has_one :featured_scenario, dependent: :destroy

  attr_accessor :api_session_id

  validates :user_id,     presence: true
  validates :scenario_id, presence: true
  validates :title,       presence: true
  validates :end_year,    presence: true
  validates :area_code,   presence: true

  serialize :scenario_id_history, Array

  # Order as to be provided to the custom curves chooser. Scenarios with the given
  # end_year go on top, scenarios with the given area_code are not included.
  def self.custom_curves_order(end_year, area_code)
    scenarios = all.where.not(area_code: area_code)
    top = scenarios.where(end_year: end_year).order(updated_at: :desc)
    bottom = scenarios.where.not(end_year: end_year).order(end_year: :desc, updated_at: :desc)
    top + bottom
  end

  def self.batch_load(saved_scenarios, options = {})
    saved_scenarios = saved_scenarios.to_a
    ids = saved_scenarios.map(&:scenario_id)
    loaded = Api::Scenario.batch_load(ids, options).index_by(&:id)

    saved_scenarios.each do |saved|
      saved.scenario = loaded[saved.scenario_id]
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

  def add_id_to_history(scenario_id)
    scenario_id_history.shift if scenario_id_history.count >= 20
    scenario_id_history << scenario_id
  end

  def scenario=(x)
    @scenario = x
    self.scenario_id = x.id unless x.nil?
  end

  def build_setting(user: nil)
    if user && (user.id == self.user_id)
      Setting.load_from_scenario(
        scenario, active_saved_scenario: { id: id, title: title }
      )
    else
      Setting.load_from_scenario(scenario)
    end
  end

  # Public: Determines if this scenario can be loaded.
  def loadable?
    Api::Area.code_exists?(area_code)
  end

  def days_until_last_update
    (Time.current - updated_at) / 60 / 60 / 24
  end

  def featured?
    featured_scenario.present?
  end

  def localized_title(locale)
    featured? ? featured_scenario.localized_title(locale) : title
  end

  def localized_description(locale)
    featured? ? featured_scenario.localized_description(locale) : description
  end
end
