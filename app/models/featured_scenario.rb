# frozen_string_literal: true

# Features a scenario such that it appears on the front page.
class FeaturedScenario < ApplicationRecord
  # The groups to which a featured scenario may be assigned.
  GROUPS = %w[national northern_ireland regional municipal].freeze

  # Groups as they are sorted on the front page. Scenarios in a group which isn't explicitly named
  # are sorted in `:rest`, while those with no group come last.
  SORTABLE_GROUPS = [*GROUPS, :rest, nil].freeze

  belongs_to :saved_scenario
  validates :saved_scenario_id, presence: true, uniqueness: true
  validates :description_en, :description_nl, :title_en, :title_nl, presence: true
  validates :group, inclusion: GROUPS

  delegate :area_code, :end_year, :scenario_id, to: :saved_scenario

  # Public: Given an array of scenarios, an array of display groups, groups the
  # scenarios according to their display_group, in the order specified in the
  # group array.
  #
  # For example:
  #
  #   grouped_scenarios(..., ['one', 'two', :rest])
  #
  # The special :rest key may be placed anywhere; for example, if you want to
  # display all scenarios belonging to a group, prior to "Other" scenarios:
  #
  #   grouped_scenarios(..., ['one', 'two', :rest, 'other'])
  #
  # Returns an array of hashes. Each hash has a :name key with the groups name,
  # and a :scenarios key containing all the matching scenarios.
  def self.in_groups(featured_scenarios, groups = SORTABLE_GROUPS)
    grouped   = Hash.new { |hash, key| hash[key] = [] }
    scenarios = featured_scenarios.sort_by { |fs| fs.localized_title(I18n.locale) }

    group_for = lambda do |group|
      { name: group, scenarios: grouped[group] } if grouped[group].any?
    end

    scenarios.each do |fs, _|
      grouped[fs.group].push(fs)
    end

    # Sort "unspecified" groups by their key.
    unspecified = (grouped.keys - groups).sort_by(&:to_s)

    with_unspecified = groups.dup

    with_unspecified[groups.index(:rest)] = unspecified
    with_unspecified.flatten!

    with_unspecified.map do |group|
      if group == :rest
        (grouped.keys - groups).map(&group_for)
      else
        group_for.call(group)
      end
    end.flatten.compact
  end

  def self.in_groups_per_end_year(featured_scenarios, groups=SORTABLE_GROUPS)
    scenarios = featured_scenarios.group_by(&:end_year)
    scenarios.each do |end_year, year_scenarios|
      scenarios[end_year] = FeaturedScenario.in_groups(year_scenarios, groups)
    end

    scenarios
  end

  def localized_title(locale)
    (locale == :nl ? title_nl : title_en) || saved_scenario.title
  end

  def localized_description(locale)
    (locale == :nl ? description_nl : description_en) || saved_scenario.description
  end
end
