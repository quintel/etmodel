class Api::Scenario < ActiveResource::Base
  PRESET_GROUPS = [
    'Actueel',
    'High Energy Productivity Growth',
    'Watt Nu?! 2013',
    'Watt Nu?! 2012',
    'EC2013',
    'Regional',
    :rest,
    nil
  ].freeze

  self.site = "#{APP_CONFIG[:api_url]}/api/v3"

  def self.batch_load(ids)
    HTTParty
      .get(self.site.merge("scenarios/#{ids.join(',')}/batch"))
      .map { |scenario| new(scenario) }
  end

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
  def self.in_groups(scenarios, groups = PRESET_GROUPS)
    grouped   = Hash.new { |hash, key| hash[key] = [] }
    scenarios = scenarios.sort_by { |s| [s.ordering || 9999, s.title || ''] }

    group_for = lambda do |group|
      { name: group, scenarios: grouped[group] } if grouped[group].any?
    end

    scenarios.each do |scenario, data|
      grouped[scenario.display_group].push(scenario)
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

  def self.scaling_from_params(params)
    if params[:scaling_attribute]
      { area_attribute:  params[:scaling_attribute],
        value:           params[:scaling_value],
        has_agriculture: params[:has_agriculture] == '1',
        has_energy:      params[:has_energy] == '1',
        has_industry:    params[:has_industry] == '1' }
    else
      {}
    end
  end

  # description for a locale is enclosed in
  # <span class='en'>
  # </span>
  def description_for_locale(locale)
    html = Nokogiri::HTML.parse(description)
    html.css(".#{locale}").inner_html
  end

  # The JSON request returns a string. Let's make it a DateTime object
  def parsed_created_at
    DateTime.parse(created_at) if created_at
  end

  def days_old
    (Time.now - parsed_created_at) / 60 / 60 / 24
  end

  # Returns an HTTParty::Reponse object with a hash of the scenario user_values
  def all_inputs
    HTTParty.get("#{APP_CONFIG[:api_url]}/api/v3/scenarios/#{id}/inputs")
  end

  # The value which is used for sorting. Used on the preset scenario list
  def sorting_value
    respond_to?(:ordering) ? ordering : 0
  end
end
