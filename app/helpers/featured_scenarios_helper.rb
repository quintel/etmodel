# frozen_string_literal: true

# Helper for creating featured scenarios.
module FeaturedScenariosHelper
  def featured_scenario_groups_collection
    FeaturedScenario::GROUPS.map { |option| [I18n.t("scenario.#{option}"), option] }
  end
end
