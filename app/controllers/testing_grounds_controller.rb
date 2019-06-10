class TestingGroundsController < ApplicationController
  def create
    result = CreateTestingGroundScenario.call(
      Current.setting.api_session_id,
      current_user
    )

    if result.successful?
      redirect_to etmoses_url(result.value.id)
    else
      flash[:error] = result.errors.join(', ')
      redirect_to play_path
    end
  end

  private

  def etmoses_url(scenario_id)
    "#{APP_CONFIG[:etmoses_url]}/testing_grounds/import?" \
    "scenario_id=#{scenario_id}"
  end
end
