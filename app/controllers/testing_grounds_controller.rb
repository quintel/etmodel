class TestingGroundsController < ApplicationController
  def create
    scenario_params = { title: "#{Current.setting.api_session_id} scaled",
                        description: "",
                        api_session_id: Current.setting.api_session_id }

    if Scenario::Creator.new(current_user, scenario_params).create
      redirect_to "#{APP_CONFIG[:et_loader_url]}/testing_grounds/import?scenario_id=#{Current.setting.api_session_id}"
    else
      redirect_to play_path
    end
  end
end
