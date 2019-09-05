# frozen_string_literal: true

module Embeds
  # Generates an embedable version of pico
  class PicosController < ApplicationController
    layout false

    def show
      respond_to do |format|
        format.html do
          set_scenario_area
          @pico_module = params[:pico_module]
        end
      end
    end

    private

    def set_scenario_area
      scenario = Api::Scenario.find(Current.setting.api_session_id)
      @area = Embeds::PicoArea.find_by_area_code(scenario.area_code)
    end
  end
end
