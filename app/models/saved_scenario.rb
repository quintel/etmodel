# == Schema Information
#
# Table name: saved_scenarios
#
#  id                  :integer          not null, primary key
#  scenario_id         :integer          not null
#  scenario_id_history :string
#  title               :string           not null
#  description         :string
#  area_code           :string           not null
#  end_year            :integer          not null
#  created_at          :datetime
#  updated_at          :datetime
#

# A scenario saved by a user for safe-keeping.
#
# Contains a record of all the scenario IDs for previous versions of the scenario.
class SavedScenario < ApplicationRecord
  include Discard::Model

  # Discarded scenarios are deleted automatically after this period.
  AUTO_DELETES_AFTER = 60.days

  has_many :saved_scenario_users, dependent: :destroy
  has_many :users, through: :saved_scenario_users

  has_many :multi_year_chart_saved_scenarios, dependent: :destroy
  has_many :multi_year_charts, through: :multi_year_chart_saved_scenarios

  has_one :featured_scenario, dependent: :destroy

  validates :scenario_id, presence: true
  validates :title,       presence: true
  validates :end_year,    presence: true
  validates :area_code,   presence: true

  serialize :scenario_id_history, Array

  # Order as to be provided to the custom curves chooser. Scenarios with the given
  # end_year go on top, scenarios with the given area_code are not included.
  def self.custom_curves_order(end_year, area_code)
    scenarios = available.where.not(area_code: area_code)
    top = scenarios.where(end_year: end_year).order(updated_at: :desc)
    bottom = scenarios.where.not(end_year: end_year).order(end_year: :desc, updated_at: :desc)
    top + bottom
  end

  def self.batch_load(saved_scenarios, options = {})
    saved_scenarios = saved_scenarios.to_a
    ids = saved_scenarios.map(&:scenario_id)
    loaded = Engine::Scenario.batch_load(ids, options).index_by(&:id)

    saved_scenarios.each do |saved|
      saved.scenario = loaded[saved.scenario_id]
    end

    saved_scenarios
  end

  # Returns all saved scenarios whose areas are avaliable.
  def self.available
    kept.where(area_code: Engine::Area.keys)
  end

  # Public: Destroys all saved scenarios which were discarded some time ago.
  def self.destroy_old_discarded!
    discarded
      .where(discarded_at: ..SavedScenario::AUTO_DELETES_AFTER.ago)
      .destroy_all
  end

  def self.owned_by?(user)
    joins(:saved_scenario_users)
      .where(
        'saved_scenario_users.user_id': user.id,
        'saved_scenario_users.role_id': User::ROLES.key(:scenario_owner)
      )
  end

  def self.collaborated_by?(user)
    joins(:saved_scenario_users)
      .where(
        'saved_scenario_users.user_id': user.id,
        'saved_scenario_users.role_id': User::ROLES.key(:scenario_collaborator)..
      )
  end

  def self.viewable_by?(user)
    joins(:saved_scenario_users)
      .where(
        'saved_scenario_users.user_id': user.id,
        'saved_scenario_users.role_id': User::ROLES.key(:scenario_viewer)..
      )
  end

  # Public: Customizes the attributes returned by `as_json` and `to_xml`. Omits the deprecated `settings` attribute
  #
  # Returns a hash.
  def serializable_hash(options = {})
    # Options is sometimes explictly nil.
    options ||= {}

    super(options.merge(
      except: (options[:except] || [])
    ))
  end

  def scenario(engine_client)
    unless engine_client.is_a?(Faraday::Connection)
      raise 'SavedScenario#scenario expects an HTTP client as its first argument'
    end

    @scenario ||= FetchAPIScenario.call(engine_client, scenario_id).or(nil)
  end

  def add_id_to_history(scenario_id)
    return if !scenario_id || scenario_id_history.include?(scenario_id)

    scenario_id_history.shift if scenario_id_history.count >= 100
    scenario_id_history << scenario_id
  end

  # Restores the scenario id to the given version
  # Returns the discarded scenarios from the history
  def restore_version(scenario_id)
    return unless scenario_id && scenario_id_history.include?(scenario_id)

    discard_no = scenario_id_history.index(scenario_id)
    discarded = scenario_id_history[discard_no + 1...]

    self.scenario_id = scenario_id
    self.scenario_id_history = scenario_id_history[...discard_no]

    discarded
  end

  def scenario=(x)
    @scenario = x
    self.scenario_id = x.id unless x.nil?
  end

  # Public: Determines if this scenario can be loaded.
  def loadable?
    Engine::Area.code_exists?(area_code)
  end

  def days_until_last_update
    (Time.current - updated_at) / 60 / 60 / 24
  end

  def featured?
    featured_scenario.present?
  end

  def localized_title(locale)
    featured? ? featured_scenario.localized_title(locale) : title
  end

  def localized_description(locale)
    featured? ? featured_scenario.localized_description(locale) : description
  end

  # Updates a saved scenario with parameters from the API controller.
  def update_with_api_params(params)
    incoming_id = params[:scenario_id]
    update_scenario_id(incoming_id)

    self.attributes = params.except(:discarded, :scenario_id)

    if params.key?(:discarded)
      if params[:discarded]
        self.discarded_at ||= Time.current
      else
        self.discarded_at = nil
      end
    end

    save
  end

  # Safe updating of scenario_id for the API, checks if the id is new, or was
  # already part of the history
  def update_scenario_id(incoming_id)
    return unless incoming_id
    return if incoming_id == scenario_id

    if scenario_id_history.include?(incoming_id)
      restore_version(incoming_id)
    else
      add_id_to_history(scenario_id)
      self.scenario_id = incoming_id
    end
  end

  # Returns an array containing the current and historical scenario ids
  def version_scenario_ids
    [scenario_id] + scenario_id_history.reverse
  end

  def as_json(options = {})
    options[:except] ||= %i[discarded_at]

    super(options).merge(
      'discarded' => discarded_at.present?,
      'owners' => owners.map(&:user).map { |u| u.as_json(only: %i[id name]) }
    )
  end

  # Returns a collection of SavedScenarioUsers
  def owners
    saved_scenario_users.where(role_id: User::ROLES.key(:scenario_owner))
  end

  # Returns a collection of SavedScenarioUsers
  def collaborators
    saved_scenario_users.where(role_id: User::ROLES.key(:scenario_collaborator))
  end

  # Returns a collection of SavedScenarioUsers
  def viewers
    saved_scenario_users.where(role_id: User::ROLES.key(:scenario_viewer))
  end

  def single_owner?
    owners.count == 1
  end

  def owner?(user)
    return false if user.blank?

    ssu = saved_scenario_users.find_by(user_id: user.id)
    ssu.present? && ssu.role_id == User::ROLES.key(:scenario_owner)
  end

  def collaborator?(user)
    return false if user.blank?

    ssu = saved_scenario_users.find_by(user_id: user.id)
    ssu.present? && ssu.role_id >= User::ROLES.key(:scenario_collaborator)
  end

  def viewer?(user)
    return false if user.blank?

    return true if user.admin?

    ssu = saved_scenario_users.find_by(user_id: user.id)
    ssu.present? && ssu.role_id >= User::ROLES.key(:scenario_viewer)
  end

  # Convenience method to quickly set the owner for a scenario, e.g. when creating it as
  # Scenario.create(user: User). Only works to set the first user, returns false otherwise.
  def user=(user)
    return unless user.present? && saved_scenario_users.empty? && valid?

    SavedScenarioUser.create(
      saved_scenario: self,
      user: user,
      role_id: User::ROLES.key(:scenario_owner)
    )
  end
end
