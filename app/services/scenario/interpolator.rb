# Receives a 2050 Api::Scenario and creates scenarios for 2020, 2030, and 2040
# with input values interpolated from the 2050 scenario.
class Scenario::Interpolator
  INTERPOLATE_YEARS = [2023, 2030, 2040].freeze

  def self.call(api_scenario)
    new(api_scenario).scenarios
  end

  def initialize(api_scenario)
    @api_scenario = api_scenario
  end

  def scenarios
    INTERPOLATE_YEARS.map do |year|
      HTTParty.post(
        "#{ APP_CONFIG[:api_url] }/api/v3/scenarios/interpolate",
        body: {
          scenario: {
            scenario_id: @api_scenario.id,
            end_year: year
          }
        }
      )
    end
  end
end
