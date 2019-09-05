# frozen_string_literal: true

module Embeds
  # Generates an embedable version of pico
  class PicosController < ApplicationController
    layout false

    def show
      @area = Embeds::PicoArea.find_by_area_code(Current.setting.area_code)
      @pico_module = params[:pico_module]
    end
  end
end
