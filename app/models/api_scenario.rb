class ApiScenario < Scenario

  validates_presence_of :api_session_key, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :api_session_key, :on => :create, :message => "must be unique"

  # Expired ApiScenario will be deleted by rake task :clean_expired_api_scenarios
  scope :expired, lambda { where(['updated_at < ?', Date.today - 14]) }

  def to_param
    api_session_key
  end

  def scenario_id=(scenario_id)
    if scenario = Scenario.find(scenario_id)
      copy_scenario_state(scenario)
    end
  end

  def api_errors(test_scenario)
    if used_groups_add_up?
       []
    else
      groups = used_groups_not_adding_up
      remove_groups_and_elements_not_adding_up!(test_scenario)
      groups.map do |group, elements|
        element_ids = elements.map{|e| "#{e.id} [#{e.key || 'no_key'}]" }.join(', ')
        "Group '#{group}' does not add up to 100. Elements (#{element_ids}) "
      end
    end
  end

  # used for api/v1/api_scenarios.json
  def as_json(options={})
    super(
      :only => [:api_session_key, :user_values, :country, :region, :end_year, :start_year, :id]
    )
  end
end

# == Schema Information
#
# Table name: scenarios
#
#  id                 :integer(4)      not null, primary key
#  author             :string(255)
#  title              :string(255)
#  description        :text
#  user_updates       :text
#  created_at         :datetime
#  updated_at         :datetime
#  user_values        :text
#  end_year           :integer(4)      default(2040)
#  country            :string(255)
#  in_start_menu      :boolean(1)
#  region             :string(255)
#  user_id            :integer(4)
#  complexity         :integer(4)      default(3)
#  scenario_type      :string(255)
#  preset_scenario_id :integer(4)
#  type               :string(255)
#  api_session_key    :string(255)
#  lce_settings       :text
#
