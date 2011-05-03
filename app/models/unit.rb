class Unit
  def self.convert_to(number, unit)
    send("to_#{unit.downcase}", number)
  end

#  def to_gbp(eur)
#    eur * 1.3
#  end

  ##
  # Creates percentage out of a fraction
  # to_percentage(0.2) => 20%
  #
  def self.to_percentage(fraction)
    fraction * 100.0
  end

  def self.to_billions(number)
    number.to_f / 10**9
  end

  def self.to_millions(number)
    number.to_f / 10**6
  end

  ##
  # Converts per_mj to per_mwh
  #
  def self.to_per_mwh(per_mj); per_mj * SECS_PER_HOUR; end

  ##
  # Converts mj to mwh
  #
  def self.to_mwh(mj); mj / SECS_PER_HOUR; end

  ##
  # Converts per_mj_yr to per_mwh
  #
  def self.to_per_mwh(per_mj_yr); per_mj_yr * SECS_PER_HOUR * HOURS_PER_YEAR; end

  ##
  # Converts mj to pj
  #
  def self.to_pj(mj); to_billions(mj); end

  ##
  #
  #
  def self.to_pj_from_mw(mw); mw * (HOURS_PER_YEAR / 10**6) * MWH_TO_GJ; end
end
