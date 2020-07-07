/* globals Quantity Metric */

/**
 * Converts queries whose unit is a factor into a percentage.
 */
function convertFactor(value, unit, options) {
  if (unit === 'factor') {
    return [value * 100, '%', options];
  }

  return [value, unit, options];
}

/**
 * Sets the precision to a value which can be understood by Quantity and Metric.
 */
function setPrecision(value, unit, options) {
  var precision;

  if (options.precision !== undefined) {
    precision = parseInt(options.precision, 10);
  } else {
    precision = 0;
  }

  return [value, unit, _.extend({}, options, { precision: precision })];
}

function nicifyLargeNumber(value, unit, options) {
  var divisor;

  if (options.precision < 0) {
    // eslint-disable-next-line no-restricted-properties
    divisor = Math.pow(10, Math.abs(options.precision));

    if (value > divisor) {
      // Don't round numbers smaller than the divisor. For exmaple, if rounding
      // to the nearest thousand, allow "9999" to remain untouched.
      return [
        Math.round(value / divisor) * divisor,
        unit,
        Object.assign({}, options, { precision: 0 })
      ];
    }

    return [value, unit, Object.assign({}, options, { precision: 0 })];
  }

  return [value, unit, options];
}

/**
 * Converts a Quantity-supported value to a string representing the value
 * and unit in the users locale.
 */
function formatQuantityValue(value, unit, options) {
  var quant = new Quantity(value, unit);

  if (options.as) {
    quant = quant.to(options.as);
  }

  return [
    quant.format({ precision: options.precision }),
    options.as || unit,
    options
  ];
}

/**
 * Converts a non-Quantity-supported value to a string representing the value
 * and unit in the users locale.
 */
function formatNonQuantityValue(value, unit, options) {
  if (options.as === '+%') {
    return [
      Metric.percentage_to_string(value, true, options.precision),
      '%',
      options
    ];
  }

  return [
    Metric.autoscale_value(value, unit, options.precision),
    unit,
    options
  ];
}

/**
 * Generic function which converts the value to a string representing the value
 * and unit in the users locale.
 */
function localiseValue(value, unit, options) {
  if (Quantity.isSupported(unit)) {
    return formatQuantityValue(value, unit, options);
  }

  return formatNonQuantityValue(value, unit, options);
}

/**
 * Values to be shown without a unit will have the unit suffix removed.
 */
function stripUnit(value, unit, options) {
  if (Object.prototype.hasOwnProperty.call(options, 'noUnit')) {
    return [value.split(' ')[0], unit, options];
  }

  return [value, unit, options];
}

/**
 * Given a value, unit, and options, formats a query value for display.
 */
// eslint-disable-next-line no-unused-vars
function formatValue(value, unit, options) {
  var result = [
    convertFactor,
    setPrecision,
    nicifyLargeNumber,
    localiseValue,
    stripUnit
  ].reduce(
    function(memo, func) {
      return func.apply(this, memo);
    },
    [value, unit, options]
  );

  return ('' + result[0]).trim();
}

/**
 * Formats the result of executing a query.
 */
// eslint-disable-next-line no-unused-vars
function formatQueryResult(result, options) {
  return formatValue(
    options.period === 'present' ? result.present : result.future,
    result.unit,
    options
  );
}
