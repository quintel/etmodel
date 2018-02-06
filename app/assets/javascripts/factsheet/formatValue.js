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

/**
 * Converts a Quantity-supported value to a string representing the value
 * and unit in the users locale.
 */
function formatQuantityValue(value, unit, options) {
  var quant = new Quantity(value, unit);

  if (options.as) {
    quant = quant.to(options.as);
  } else {
    quant = quant.smartScale();
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
  if (options.hasOwnProperty('noUnit')) {
    return [value.split(' ')[0], unit, options];
  }

  return [value, unit, options];
}

/**
 * Given a value, unit, and options, formats a query value for display.
 */
// eslint-disable-next-line no-unused-vars
function formatValue(value, unit, options) {
  var result = [convertFactor, setPrecision, localiseValue, stripUnit].reduce(
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
function formatQueryResult(result, options) {
  return formatValue(
    options.period === 'present' ? result.present : result.future,
    result.unit,
    options
  );
}
