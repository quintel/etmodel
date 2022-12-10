# frozen_string_literal: true

module Embeds
  # This is a simple wrapper/decorator for Engine::Area.
  class PicoArea < SimpleDelegator
    TYPES             = Embeds::Pico::AreaType::ALL
    FALLBACK_TYPE     = Embeds::Pico::AreaType::Country
    UNSUPPORTED_TYPES = [Embeds::Pico::AreaType::Country,
                         Embeds::Pico::AreaType::Res].freeze

    def self.find_by_area_code(area_code)
      new Engine::Area.find(area_code)
    end

    # Sorry for the dutch. PICO is in dutch...
    def area_name
      return 'Nederland' if type == Embeds::Pico::AreaType::Country

      area.sub(/\A[^_]*/, '').humanize
    end

    def type
      TYPES.find { |type| area.match?(type.matcher) } || FALLBACK_TYPE
    end

    def select_value
      type.select_value_from(area)
    end

    def to_js
      "{areatype:'#{type.key}', areaname:'#{area_name}'," \
        " selectfield: '#{type.select_field}', selectvalue:'#{select_value}'}"
    end

    def supported?
      area == 'nl' || !UNSUPPORTED_TYPES.include?(type)
    end
  end
end
