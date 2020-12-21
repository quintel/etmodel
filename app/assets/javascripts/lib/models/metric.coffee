# Given a number, determines an appropriate precision to use when formatting
# the number.
#
# max - An maximum precision for the number. Defaults to 2.
#
# Returns a number.
calculate_precision = (number, max = 2) ->
  # Automatically determine how many significant decimal places are present in
  # the number.
  #
  # .split('.')[1] => the decimal places
  #
  str_value = number.toFixed(20)

  precision = _.min([
    str_value.split('.', 2)[1]?.replace(/0+$/).length || 0, max
  ])

  # Chop off any trailing zeros. This will be the case if the original number
  # was something like 1.000002.
  if precision > 0
    pvalue = Metric.round_number(number, precision)
    pvalue = pvalue.split('').reverse().join('')

    if match = pvalue.match(/^0+/)
      precision = Math.min(precision - match.length, 0)

  precision

# Given the name of a unit used in the node details table, attempts to
# translate it, but returns the unit as-given if no translation was found.
translate_node_details_unit = (unit) ->
  I18n.t(
    "node_details.units.#{unit.trim()}",
    defaults: [{ message: unit }]
  )

# Formats a value (with unit) shown in the node details table.
format_node_detail_value = (value, unit) ->
  num = Number.parseFloat(value)

  if !isNaN(num)
    if unit.slice(0, 3) == 'EUR'
      formatted = I18n.toCurrency(num, precision: 0, unit: '€')

      if unit.indexOf('/') != -1
        sub_units = unit
          .split('/')
          .slice(1)
          .map((sub_unit) -> translate_node_details_unit(sub_unit))

        formatted = "#{formatted} / #{sub_units.join(' / ')}"

      formatted
    else
      Metric.autoscale_value(
        num,
        unit,
        if unit.slice(0, 4) == 'hour' then 0 else 'auto'
      )
  else if unit == 'boolean'
    I18n.t("node_details.texts.#{if value then 'yes' else 'no'}")
  else if unit
    "#{value} #{translate_node_details_unit(unit)}"
  else
    I18n.t(
      "node_details.texts.#{value.toString()}",
      defaults: [{ message: value }]
    )

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
      when "MT"
        u = "ton"
        power += 2
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
  autoscale_value: (x, unit, precision = 'auto', scaleDown = true) ->
    if scaleDown and Quantity.isSupported(unit)
      return new Quantity(x, unit).smartScale().format(precision: precision)

    if x == 0
      pow = 0
      value = 0
      precision = 0
    else if ! scaleDown or unit is 'hours' or unit is 'year'
      pow = 0
      value = @round_number(x, precision)
    else
      pow = @power_of_thousand(x)

      if pow < 0
        value = x
        pow   = 0
      else
        value = x / Math.pow(1000, pow)

      # Allow more relaxed scaling down of unitless ("#") values.
      scalePoint = if unit is '#' then 10 else 1

      if scaleDown and pow > 0 and value > 0 and value < scalePoint
        pow -= 1
        value *= 1000

      if precision is 'auto'
        precision = calculate_precision(value)

      value = @round_number(value, precision)

    switch unit
      when '%'
         @percentage_to_string(x, false, precision)
      when 'MJ'
         "#{value} #{@scaling_in_words(pow, 'joules')}"
      when 'PJ'
         "#{value} #{@scaling_in_words(pow + 3, 'joules')}"
      when 'EJ'
         "#{value} #{@scaling_in_words(pow + 4, 'joules')}"
      when 'MW'
         "#{value} #{@scaling_in_words(pow + 2, 'watt')}"
      when 'MT'
         "#{value} #{@scaling_in_words(pow + 2, 'ton')}"
      when 'euro'
        if _.isNull(x)
          '-'
        else
          @euros_to_string x, true, precision
      when 'mln_euro'
        @euros_to_string x * 1000000, true, precision
      when 'bln_euro'
        @euros_to_string x * 1000000000, true, precision
      when 'man_years'
        "#{@round_number x, 0} #{@scaling_in_words(0, 'man_years')}"
      when 'FTE'
        "#{@round_number x, 0} #{@scaling_in_words(0, 'FTE')}"
      when 'Eur/Mwh'
        "#{@round_number x, 2} €/MWh"
      when 'Eur/MWhe'
        "#{@round_number x, 2} €/MWhe"
      when 'Eur/MWe'
        "#{@round_number x, 2} €/MWe"
      when 'MEur/MWe'
        "#{@round_number x, 2} M€/MWe"
      when '#'
        "#{value} #{@scaling_in_words(pow, 'nounit')}"
      when 'years'
        "#{value} #{@scaling_in_words(0, 'years')}"
      when 'hours'
        "#{value} #{@scaling_in_words(0, 'hours')}"
      when 'hour / year'
        "#{value} #{@scaling_in_words(0, 'hours_per_year')}"
      else
        value

  # formatters

  # x: the value - no transformations on it
  # prefix: if true, add a leading + on positive values
  #  precision: default = 1, the number of decimal points
  # pts(10) => 10%
  # pts(10, true) => +10%
  # pts(10, true, 2) => 10.00%
  percentage_to_string: (x, prefix, precision) ->
    precision ?= 1
    prefix = prefix || false
    value = @round_number(x, precision)
    value = "+#{value}" if prefix && value > 0.0
    value = "0.0" if value == "+0.0" || value == "-0.0"
    "#{value}%"

  # as format_percentage, but multiplying the value * 100
  ratio_as_percentage: (x, prefix, precision) ->
    return x if /\%/.test(x)
    return '-' if (_.isNaN(x) || _.isNull(x) || x == 'null')
    return @percentage_to_string(x * 100, prefix, precision)

  #   very specific I'm keeping it separated from autoscale_value.
  #   1_000_000     => &euro;1mln
  #   -1_000_000    => -&euro;1mln
  #   1_000_000_000 => &euro;1bln
  #   The unit_suffix parameters adds a translated mln/bln suffix
  euros_to_string: (x, unit_suffix, precision) ->
    precision = 2 if precision == 'auto'
    return '-' if (_.isNaN(x) || x == 'null')
    prefix = if x < 0 then "-" else ""
    abs_value = Math.abs(x)
    scale     = @power_of_thousand(x)

    if scale < 0
      precision = scale = 0
      value = abs_value
    else
      value = abs_value / Math.pow(1000, scale)

    suffix    = ''
    rounded   = @round_number(value, precision).toString()

    if unit_suffix and abs_value >= 1000
      suffix = I18n.t('units.currency.' + @power_of_thousand_to_string(scale))

    # When the number is > 1000, we can safely trim trailing decimal zeroes.
    if abs_value >= 1000 && rounded.match(/\./)
      rounded = rounded.replace(/0+$/, '')
      rounded = rounded[0..-2] if rounded.slice(-1) is '.'

    "#{prefix}€#{rounded} #{suffix}"

  # support methods
  #

  # 0-999: 0, 1000-999999: 1, ...
  power_of_thousand: (x) ->
    if x is 0 then 0 else
      Math.trunc(Math.log(Math.abs(x)) / Math.log(1000))

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

  # Relates powers of a thousand to their SI symbols.
  power_symbols: ['', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']

  round_number : (value, precision) ->
    return false unless value?
    value.toFixed(precision)

  # This is used only in the node info popup
  node_detail_format: (x, unit) ->
    format_node_detail_value(x, unit)

  # sets the right number of decimal digits
  format_number: (x) ->
    abs = Math.abs(x)
    if abs >= 1000
      @round_number x, 0
    else if abs >= 1
      @round_number x, 2
    else if abs > 0 && abs <= 0.001
      @round_number x, 5
    else if abs == 0
      0
    else
      @round_number x, 3
