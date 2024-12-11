# frozen_string_literal: true

# Helper for creating featured scenarios.
module FeaturedScenariosHelper
  def in_groups_per_end_year(scenarios)
    grouped_by_year = scenarios.group_by(&:end_year)
    grouped_by_year.transform_values do |scenarios_for_year|
      scenarios_for_year.group_by(&:group).map do |group, scenarios|
        { name: group, scenarios: scenarios }
      end
    end
  end
end
