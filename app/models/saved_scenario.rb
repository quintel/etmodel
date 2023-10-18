# == Schema Information
#
# Table name: saved_scenarios
#
#  id                  :integer          not null, primary key
#  user_id             :integer          not null
#  scenario_id         :integer          not null
#  scenario_id_history :string
#  title               :string           not null
#  description         :string
#  area_code           :string           not null
#  end_year            :integer          not null
#  settings            :text
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

  belongs_to :user
  has_one :featured_scenario, dependent: :destroy

  validates :user_id,     presence: true
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

  # Public: Cutomizes the attributes returned by `as_json` and `to_xml`. Omits the deprecated
  # `settings` attribute, and `user_id`.
  #
  # Returns a hash.
  def serializable_hash(options = {})
    # Options is sometimes explictly nil.
    options ||= {}

    super(options.merge(
      except: (options[:except] || []) + %i[settings user_id]
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

    scenario_id_history.shift if scenario_id_history.count >= 20
    scenario_id_history << scenario_id
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
    add_id_to_history(scenario_id) if incoming_id && scenario_id != incoming_id

    # "Manual scenario reverting" by the user, e.g. setting an earlier used scenario-id
    # as the current active scenario, is not allowed.
    if scenario_id_history.include?(incoming_id)
      errors.add(
        :scenario_id,
        "Given scenario id #{incoming_id} is already present in this saved scenario's history."
      )

      return false
    end

    self.attributes = params.except(:discarded)

    if params.key?(:discarded)
      if params[:discarded]
        self.discarded_at ||= Time.current
      else
        self.discarded_at = nil
      end
    end

    save
  end

  def as_json(options = {})
    options[:except] ||= %i[discarded_at]

    super(options).merge(
      'discarded' => discarded_at.present?,
      'owner' => user.as_json(only: %i[id name]),
    )
  end
end
