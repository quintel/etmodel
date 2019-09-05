# This is a simple wrapper for Api::Area.
# Sorry for the dutch. PICO is in dutch...

class Embeds::PicoArea < SimpleDelegator
  def self.find_by_area_code(area_code)
    new Api::Area.find(area_code)
  end

  def area_name
    return "Nederland" if type == :land
    area.sub(/\A[^_]*/, "").humanize
  end

  def type
    pattern_whitelist.each do |type, pattern|
      return type if area.match?(pattern)
    end
    return :land
  end

  def to_json
    "{areaType:'#{type}', areaName:'#{area_name}'}"
  end

  private

  def pattern_whitelist
    Embeds::PICO_AREA_PATTERNS_WHITELIST
  end
end
