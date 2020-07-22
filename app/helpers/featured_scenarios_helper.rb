# frozen_string_literal: true

# Helper for creating featured scenarios.
module FeaturedScenariosHelper
  def featured_scenario_groups_collection
    options = FeaturedScenario::GROUPS.select { |item| item.is_a?(String) }
    options.map { |option| [I18n.t("scenario.#{option}"), option] }
  end
end
