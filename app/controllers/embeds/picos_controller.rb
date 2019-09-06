# frozen_string_literal: true

module Embeds
  # Generates an embedable version of pico
  class PicosController < ApplicationController
    layout false

    def show
      @area = Embeds::PicoArea.find_by_area_code(Current.setting.area_code)
      if @area.supported?
        @pico_module = params[:pico_module]
      else
        render :unsupported
      end
    end
  end
end
