# frozen_string_literal: true

# Receives a 2050 Engine::Scenario and creates scenarios for selected years, with
# input values interpolated from the source scenario. Interpolator also creates
# a duplicate of the original scenario.
class CreateMultiYearChart
  include Service

  DEFAULT_YEARS = [2023, 2030, 2040].freeze

  # Public: Creates a new multi-year chart and interpolated scenarios.
  #
  # saved_scenario - The SavedScenario to be used as the base scenario for interpolating one or more
  #                  new scenarios.
  # user           - The user to which the resulting MultiYearChart should belong.
  # years          - An optional array of years for which interpolated scenarios
  #                  will be created.
  #
  def initialize(saved_scenario, user, years = DEFAULT_YEARS)
    @saved_scenario = saved_scenario
    @user = user
    @years = (years + [@saved_scenario.end_year]).uniq
  end

  # Internal: Creats interpolated scenarios for the chosen years, and the
  # MultiYearChart records.
  #
  # Returns a ServiceResult.
  def call
    if scenarios.all?(&:successful?)
      ServiceResult.success(create_multi_year_chart)
    else
      # Any responses which did succeed, should have their protected status
      # removed, since there's no need to keep the scenario.
      clean_up_failure

      # The last response will always be the one with the errors, as we give up
      # on the first failure.
      ServiceResult.failure(scenarios.last.errors)
    end
  rescue ActiveRecord::RecordInvalid => e
    clean_up_failure

    # The user does not provide any data which should cause saving the MYC to
    # fail. Re-raise the exception so we can log it.
    raise e
  end

  private

  def create_multi_year_chart
    myc = MultiYearChart.new_from_saved_scenario(@saved_scenario, user: @user)

    scenarios.each do |sresult|
      myc.scenarios.build(scenario_id: sresult.value['id'])
    end

    MultiYearChart.transaction { myc.save! }

    myc
  end

  # Internal: Sends requests to ETEngine to create the interpolated scenarios.
  #
  # As requests are sent synchronously, this stops as soon as any one request
  # fails.
  def scenarios
    @scenarios ||= begin
      any_errors = false

      @years.filter_map do |year|
        next if any_errors

        res = InterpolateAPIScenario.call(@saved_scenario.scenario_id, year, keep_compatible: true)
        any_errors = res.failure?

        res
      end
    end
  end

  def clean_up_failure
    scenarios.each do |sresult|
      SetAPIScenarioCompatibility.dont_keep_compatible(sresult.value['id']) if sresult.successful?
    end
  end

  def api_url(*suffix)
    "#{Settings.api_url}/api/v3/scenarios/#{suffix.join('/')}"
  end
end
