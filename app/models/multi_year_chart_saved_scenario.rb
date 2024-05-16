# frozen_string_literal: true

# A saved scenario used by a MultiYearChart.
class MultiYearChartSavedScenario < ApplicationRecord
  belongs_to :multi_year_chart
  belongs_to :saved_scenario

  validate :shared_access

  private

  def shared_access
    return if saved_scenario.viewer?(multi_year_chart.user)

    errors.add(:base, :user, message: 'User must have access to both the MYC and the Saved Sceanrio')
  end
end
