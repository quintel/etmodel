class Scenario::Creator
  def initialize(user, scenario_params)
    @user = user
    @scenario_params = scenario_params
  end

  def create
    saved_scenario             = SavedScenario.new
    saved_scenario.title       = '_'
    saved_scenario.user        = @user
    saved_scenario.scenario_id = api_scenario.id
    saved_scenario.save
    saved_scenario
  end

  private

    def api_scenario
      @api_scenario ||= Api::Scenario.create(scenario: et_engine_scenario_params)
    end

    def et_engine_scenario_params
      { scenario: @scenario_params.merge(api_scenario_params) }
    end

    def api_scenario_params
      { protected: true,
        source: 'ETM',
        scenario_id: @scenario_params.delete(:api_session_id) }
    end
end
