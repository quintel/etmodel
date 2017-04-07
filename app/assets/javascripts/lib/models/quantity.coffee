POWERS = [
  { prefix: 'Y', multiple: 1e24, i18n: 'septillions' },
  { prefix: 'Z', multiple: 1e21, i18n: 'sextillions' }
  { prefix: 'E', multiple: 1e18, i18n: 'quintillions' }
  { prefix: 'P', multiple: 1e15, i18n: 'quadrillions' }
  { prefix: 'T', multiple: 1e12, i18n: 'trillions' }
  { prefix: 'G', multiple: 1e9,  i18n: 'billions' }
  { prefix: 'M', multiple: 1e6,  i18n: 'millions' }
  { prefix: 'k', multiple: 1e3,  i18n: 'thousands' }
  { prefix: '',  multiple: 1,    i18n: 'unit' }
]

BASE_UNITS = [
  { name: 'FTE' }
  { name: 'g' }
  { name: 'J' }
  { name: 'm' }
  { name: 'm2', i18n: 'm2' }
  { name: 'm3', i18n: 'm3' }
  { name: 'T' }
  { name: 'W' }
  { name: 'Wh' }
  { name: 'ln' }
]

# ------------------------------------------------------------------------------

maxPower = _.max(POWERS, (p) -> p.multiple)
minPower = _.min(POWERS, (p) -> p.multiple)

compiledUnits = {}

for base in BASE_UNITS
  for power in POWERS
    name = "#{ power.prefix }#{ base.name }"
    compiledUnits[name] = { name, base, power }

# Internal: Retrieves a compiled unit by its full name (e.g. "PJ", "Mton") or
# raises an error if the unit does not exist.
getUnit = (name) ->
  if Quantity.isSupported(name)
    compiledUnits[name]
  else
    throw "Unknown unit: #{ name }"

# Internal: Given a unit, returns the I18n describing the unit.
i18nKey = (unit) ->
  "units.#{ unit.base.i18n }.#{ unit.power.i18n }"

# ------------------------------------------------------------------------------

# Support for the "mln" input unit.

mlnBase = { name: 'ln', i18n: 'ln' }

compiledUnits['ln']  = { name: 'ln',  base: mlnBase, power: POWERS[8] }
compiledUnits['kln'] = { name: 'kln', base: mlnBase, power: POWERS[7] }
compiledUnits['Mln'] = { name: 'mln', base: mlnBase, power: POWERS[6] }

compiledUnits['mln'] = {
  name: 'mln', base: mlnBase,
  power: { prefix: 'm', multiple: 1e6, i18n: 'millions' }
}

# Support for unitless numbers.

compiledUnits['#'] = {
  name: '#',
  base: { name: '#', i18n: 'nounit' },
  power: minPower
};

# ------------------------------------------------------------------------------

class @Quantity
  # Public: Creates a new Quantity.
  #
  # value - The numeric value; the amount of "stuff".
  # unitName - The name of the unit being meastured. e.g. 'PJ', 'kton', etc).
  #
  # Returns a Quantity.
  constructor: (@value, unitName) ->
    @unit = getUnit(unitName)

  # Public: Converts the quantity to a different quantity.
  #
  # For example:
  #
  #   new Quantity(8000, 'MWh').to('GWh')
  #   # => Quantity(8, 'GWh')
  #
  # Returns a Quantity.
  to: (otherName) ->
    otherUnit = getUnit(otherName)
    newValue  = @value * (@unit.power.multiple / otherUnit.power.multiple)

    new Quantity(newValue, otherUnit.name)

  # Public: The value in the "base" unit.
  #
  # For example:
  #
  #   new Quantity(5, 'Mton').toBase()
  #   # => Quantity(5000, 'ton')
  #
  # Returns a Quantity.
  toBase: ->
    @to(@unit.base.name)

  # Public: If the value contained in the unit is much larger or smaller than is
  # suitable for the unit, smartScale will return the value in a more
  # appropriate unit.
  #
  # For example:
  #
  #   new Quantity(5000000, 'J').smartScale()
  #   # => Quantity(5, 'MJ')
  #
  # Returns a Quantity.
  smartScale: ->
    value    = @toBase().value
    multiple = Math.pow(1000, Metric.power_of_thousand(value))

    power = if multiple < minPower.multiple
      minPower
    else if multiple > maxPower.multiple
      maxPower
    else
      _.find(POWERS, (x) -> x.multiple is multiple)

    if power is @unit.power then this else
      try
        @to("#{ power.prefix }#{ @unit.base.name }")
      catch
        this

  # Public: Formats the quantity as a human-readable string, using the
  # localisation options given as parameters, and defined in the unit.
  #
  # For example
  #
  #   var quantity = new Quantity('5000.2', 'PJ')
  #
  #   quantity.format()
  #   # => "5,000.2 PJ"
  #
  #   quantity.format({ precision: 0 })
  #   # => "5,000 PJ"
  #
  #   quantity.format({ delimiter: ' ', separator: ',' })
  #   # => "5 000,2 PJ"
  #
  # Note that normally you should not have to provide delimiter or separator
  # options; appropriate values will be chosen based on the user's locale
  # setting.
  #
  # Returns a string.
  format: (opts = {}) ->
    unless opts.hasOwnProperty('strip_insignificant_zeros')
      opts.strip_insignificant_zeros = true

    if opts.precision is 'auto' or not opts.precision?
      maxPrecision = opts.maxPrecision || 2

      # Automatically determine how many significant decimal places are
      # present in the number.
      #
      # .split('.')[1] => the decimal places
      #
      opts.precision = _.min(
        ["#{ @value }".split('.', 2)[1]?.length || 0, maxPrecision])

    "#{ I18n.toNumber(@value, opts) } #{ @localizedUnit() }".trim()

  localizedUnit: ->
    if @unit.base.i18n
      if I18n.t(i18nKey(@unit)).length
        I18n.t(i18nKey(@unit), defaultValue: @unit.name)
      else
        '' # Blank messages ("nounit.unit") are fine; don't fallback to default.
    else
      @unit.name

  toString: -> @format()

  # Used to coerce Quantity into numbers so that it may be used in expressions.
  #
  # For example:
  #   quantity = new Quantity(50, 'kg')
  #   quantity > 50 # false
  #   quantity > 40 # true
  #
  # Returns a number.
  valueOf: ->
    @value

  # Public: Given a number and unit, determines the most appropriate power in
  # which to display the number, and returns a function for converting and
  # formatting other values in the same way.
  #
  # For example
  #
  #   formatter = new QuantityScaler(5000, 'GJ').format
  #
  #   formatter('4000')    # => "4 TJ"
  #   formatter('400')     # => "0.4 TJ"
  #   formatter('1337000') # => "1,337 TJ"
  @scaleAndFormatBy: (maxValue, unitName, opts) ->
    bestUnit = new Quantity(maxValue, unitName).smartScale().unit.name
    (value) -> new Quantity(value, unitName).to(bestUnit).format(_.clone(opts))

  # Public: Returns if the given unit name is supported by the Quantity class.
  #
  # Returns true or false.
  @isSupported: (name) ->
    compiledUnits.hasOwnProperty(name)
