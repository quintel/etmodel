# frozen_string_literal: true

module Embeds
  # Sorry for the dutch. PICO is in dutch...
  PICO_AREA_PATTERNS_WHITELIST = {
    gemeente: /\AGM/,
    land: /\Anl/,
    provincie: /\APV/
  }.freeze
end
