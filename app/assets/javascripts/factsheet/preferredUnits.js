/* globals Quantity d3 */

/**
 * Given the gqueries from ETEngine, and a base unit (e.g. "J", "W"), determines
 * the most appropriate unit by which to format values with that unit.
 */
function preferredUnit(gqueries, baseUnit) {
  var largestUnit = new Quantity(1, baseUnit).unit;

  d3.keys(gqueries).forEach(function(gqKey) {
    var gquery = gqueries[gqKey];
    var values;

    if (!gquery.unit.match(baseUnit + '$')) {
      return;
    }

    // Allow values up to 99,999 before moving up to the next power.
    values = [
      new Quantity(gquery.present / 100, gquery.unit).smartScale().unit,
      new Quantity(gquery.future / 100, gquery.unit).smartScale().unit
    ];

    values.forEach(function(value) {
      if (value.power.multiple > largestUnit.power.multiple) {
        largestUnit = value;
      }
    });
  });

  return largestUnit.name;
}

/**
 * Given the queries from ETEngine, returns an object describing the most
 * appropriate unit by which to display each query value.
 */
// eslint-disable-next-line no-unused-vars
function preferredUnits(gqueries) {
  return ['J', 'W'].reduce(function(memo, baseUnit) {
    // eslint-disable-next-line no-param-reassign
    memo[baseUnit] = preferredUnit(gqueries, baseUnit);
    return memo;
  }, {});
}
