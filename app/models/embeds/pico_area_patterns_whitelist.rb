# frozen_string_literal: true

# Sorry for the dutch. PICO is in dutch...
module Embeds
  PICO_AREA_PATTERNS_WHITELIST = {
    gemeente: /\AGM/,
    land: /\Anl/,
    provincie: /\APV/
  }.freeze
end
