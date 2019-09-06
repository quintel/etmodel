# frozen_string_literal: true

module Embeds
  # This is a simple wrapper/decorator for Api::Area.
  class PicoArea < SimpleDelegator
    def self.find_by_area_code(area_code)
      new Api::Area.find(area_code)
    end

    # Sorry for the dutch. PICO is in dutch...
    def area_name
      return 'Nederland' if type == :land

      area.sub(/\A[^_]*/, '').humanize
    end

    # Sorry for the dutch. PICO is in dutch...
    def type
      pattern_whitelist.each do |type, pattern|
        return type if area.match?(pattern)
      end
      :land
    end

    def to_js
      "{areaType:'#{type}', areaName:'#{area_name}'}"
    end

    def supported?
      return true if area == 'nl' || type != :land

      false
    end

    private

    def pattern_whitelist
      Embeds::PICO_AREA_PATTERNS_WHITELIST
    end
  end
end
