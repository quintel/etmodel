# frozen_string_literal: true

# Features a scenario such that it appears on the front page.
class FeaturedScenario < ApplicationRecord
  # The groups to which a featured scenario may be assigned. Each group is shown on the front page
  # in the same order as defined in this array.
  GROUPS = ['national', 'regional', 'municipal', :rest, nil].freeze

  belongs_to :saved_scenario
  validates :saved_scenario_id, presence: true, uniqueness: true

  delegate :area_code, :description, :end_year, :scenario_id, :title, to: :saved_scenario

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
  def self.in_groups(featured_scenarios, groups = GROUPS)
    grouped   = Hash.new { |hash, key| hash[key] = [] }
    scenarios = featured_scenarios.sort_by { |fs| fs.saved_scenario.title }

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
end
