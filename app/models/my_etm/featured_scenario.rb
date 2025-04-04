# frozen_string_literal: true

module MyEtm
  class FeaturedScenario < ActiveResource::Base
    self.site = "#{Settings.identity.issuer}/api/v1"

    def self.in_groups_per_end_year
      Rails.cache.fetch(:featured_scenarios) do
        grouped_by_year = find(:all).group_by(&:end_year)
        grouped_by_year.transform_values do |scenarios_for_year|
          scenarios_for_year.group_by(&:group).map do |group, scenarios|
            { name: group, scenarios: scenarios }
          end
        end
      end
    end

    # Add any methods for computed or convenience values
    def localized_title(locale)
      locale == :nl ? title_nl : title_en
    end
  end
end
