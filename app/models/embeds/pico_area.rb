# This is a simple wrapper for Api::Area. I'm using this because it allows me
# not to worry about poluting it.
# Sorry for the dutch. This has to do with dependecies in PICO.
#   - "land" is the enum value that represent "country"
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

  def available_in_pico?
    pattern_whitelist.values
                     .any?{|pattern| area.match?(pattern)}
  end

  private

  def pattern_whitelist
    Embeds::PICO_AREA_PATTERNS_WHITELIST
  end
end
