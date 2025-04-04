# frozen_string_literal: true

module MyEtm
  class FeaturedScenario < Dry::Struct
    transform_keys(&:to_sym) # Ensures all keys are symbolized before initialization

    attribute :id,               Dry::Types['strict.integer']
    attribute :saved_scenario_id, Dry::Types['strict.integer']
    attribute :owner_id,          Dry::Types['strict.integer'] | Dry::Types['nominal.nil']
    attribute :group,             Dry::Types['strict.string'] | Dry::Types['nominal.nil']
    attribute :title_en,          Dry::Types['strict.string']
    attribute :title_nl,          Dry::Types['strict.string']
    attribute :version,           Dry::Types['strict.string']
    attribute :area_code,           Dry::Types['strict.string']
    attribute :end_year,          Dry::Types['strict.integer']
    attribute :author,             Dry::Types['strict.string']

    def self.in_groups_per_end_year(scenarios)
      Rails.cache.fetch(:featured_scenarios) do
        grouped_by_year = scenarios.group_by(&:end_year)
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
