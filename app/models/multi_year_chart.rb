# frozen_string_literal: true

# Represents a saved multi-year charts session. Contains one or more scenario
# which will be loaded in the MYC interface.
class MultiYearChart < ApplicationRecord
  include Discard::Model

  # Discarded scenarios are deleted automatically after this period.
  AUTO_DELETES_AFTER = 60.days

  belongs_to :user

  has_many :scenarios,
    class_name: 'MultiYearChartScenario',
    dependent: :delete_all

  validates_presence_of :user_id

  # Public: Creates a new MultiYearChart, setting some attributes to match those of the saved
  # scenario.
  #
  # scenario - The SavedScenario from which an MYC is to be created.
  # attrs    - Optional additional attributes to be set on the MultiYearChart.
  #
  # Returns an unsaved MultiYearChart.
  def self.new_from_saved_scenario(scenario, attrs)
    new({
      area_code: scenario.area_code,
      end_year: scenario.end_year,
      title: scenario.title
    }.merge(attrs))
  end

  # Public: Returns an way for the MYC app to identify this instance, to use
  # used when directing to the application.
  #
  # For example:
  #
  #   redirect_to(myc_url(myc.redirect_slug))
  #
  # Returns an array.
  def redirect_slug
    scenarios.pluck(:scenario_id).join(',')
  end

  def as_json(options = {})
    options[:except] ||= %i[area_code end_year user_id]

    super(options).merge(
      'discarded' => discarded_at.present?,
      'owner' => user.as_json(only: %i[id name]),
      'scenario_ids' => scenarios.pluck(:scenario_id).sort
    )
  end
end
