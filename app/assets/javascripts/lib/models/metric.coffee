@Metric =
  # returns the appropriate unit
  scale_unit : (value, unit) ->
    power = @power_of_thousand(value)
    # charts sometimes use custom units. Let's normalize them
    # check en/nl_units.yml to see the corresponding labels
    switch unit
      when "PJ"
        u = "joules"
        power += 3
      when "mln_euro"
        u = "euro"
        power += 2
      when "bln_euro"
        u = "euro"
        power += 3
      when "%" then return "%"
      when "MW"
        u = "watt"
        power += 2
      when "MT" then u = "ton"
      else u = unit
    unit_label = @scaling_in_words(power, u)
    return unit_label

  # scale is the power of thousand
  scale_value: (value, scale) -> value / Math.pow(1000, scale)


  calculate_performance : (now, fut) ->
    return null if now == null || fut == null || fut == 0
    return fut / now - 1

  # given a value and a unit, returns a translated string
  # uses i18n.js, so be sure the required translation keys
  # are available.
  #
  # autoscale_value(20, '%') => 20%
  # autoscale_value(1234)    => 1234
  #
  autoscale_value: (x, unit, precision = 'auto') ->
    if x == 0
      pow = 0
      value = 0
      precision = 0
    else
      pow = @power_of_thousand(x)
      # in future we should downscale, too
      pow = 0 if pow < 0
      value = x / Math.pow(1000, pow)

      if precision is 'auto'
        # Automatically determine how many significant decimal places are
        # present in the number.
        #
        # .split('.')[1] => the decimal places
        #
        str_value  = "#{ value }"
        precision = str_value.split('.', 2)[1]?.length || 0

      value = @round_number(value, precision)

    switch unit
      when '%'
        return @percentage_to_string(x)
      when 'MJ'
        return "#{value}#{@scaling_in_words(pow, 'joules')}"
      when 'PJ'
        return "#{value}#{@scaling_in_words(pow + 3, 'joules')}"
      when 'MW'
        return "#{value}#{@scaling_in_words(pow, 'watt')}"
      when 'euro'
        return "€#{value}"
      when 'man_years'
        return "#{@round_number x, 0} #{@scaling_in_words(0, 'man_years')}"
      when 'FTE'
        return "#{@round_number x, 0} #{@scaling_in_words(0, 'FTE')}"
      else
        return x

  # formatters

  # x: the value - no transformations on it
  # prefix: if true, add a leading + on positive values
  #  precision: default = 1, the number of decimal points
  # pts(10) => 10%
  # pts(10, true) => +10%
  # pts(10, true, 2) => 10.00%
  percentage_to_string: (x, prefix, precision) ->
    precision = precision || 1
    prefix = prefix || false
    value = @round_number(x, precision)
    value = "+#{value}" if prefix && value > 0.0
    "#{value}%"

  # as format_percentage, but multiplying the value * 100
  ratio_as_percentage: (x, prefix, precision)->
    return @percentage_to_string(x * 100, prefix, precision)

  #   very specific I'm keeping it separated from autoscale_value.
  #   1_000_000     => &euro;1mln
  #   -1_000_000    => -&euro;1mln
  #   1_000_000_000 => &euro;1bln
  #   The unit_suffix parameters adds a translated mln/bln suffix
  euros_to_string: (x, unit_suffix) ->
    prefix = if x < 0 then "-" else ""
    abs_value = Math.abs(x)
    scale     = @power_of_thousand(x)
    value     = abs_value / Math.pow(1000, scale)
    suffix    = ''
    if unit_suffix
     suffix = I18n.t('units.currency.' + @power_of_thousand_to_string(scale))
    rounded = @round_number(value, 1).toString()
    # If the number is < 1000, and has decimal places, make sure that the
    # number isn't truncated to something like 5.4, but instead returns 5.40.
    if (abs_value < 1000 && _.indexOf(rounded, '.') != -1)
      rounded = rounded.split('.')
      if (rounded[1] && rounded[1].length == 1)
        rounded[1] += '0'
      rounded = rounded.join('.')
    "#{prefix}&euro;#{rounded}#{suffix}"

  # support methods
  #

  # 0-999: 0, 1000-999999: 1, ...
  power_of_thousand: (x) ->
    if x is 0 then 0 else
      parseInt(Math.log(Math.abs(x)) / Math.log(1000), 10)

  # Returns the string currently used on the i18n file
  power_of_thousand_to_string: (x) -> @scale_label["#{x}"]

  # Translates a scale to a words:
  #  1000 ^ 1 = thousands
  #  1000 ^ 2 = millions
  #  etc.
  #
  # @param scale [Float] The scale that must be translated into a word
  # @param unit [String] The unit - currently {currency|joules|nounit|ton}
  # Add other units on config/locales/{en|nl}.yml
  scaling_in_words: (scale, unit) ->
    scale = 0 if _.isNaN(scale) || scale < 0
    symbol = @scale_label["#{scale}"]
    return I18n.t("units.#{unit}.#{symbol}")

  scale_label:
    "0" : 'unit'
    "1" : 'thousands'
    "2" : 'millions'
    "3" : 'billions'
    "4" : 'trillions'
    "5" : 'quadrillions'
    "6" : 'quintillions'

  round_number : (value, precision) ->
    return false unless value?
    value.toFixed(precision)

