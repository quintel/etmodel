/* globals d3 Quantity */

/**
 * Transforms the queries returned by ETEngine so that any query expressing a
 * value in some amount of joules (TJ, PJ, etc) is converted to MJ.
 */
// eslint-disable-next-line no-unused-vars
function transformGqueries(gqueries, preferredUnits) {
  var transformed = Object.assign({}, gqueries);

  function transform(value, unit, wanted) {
    return new Quantity(value, unit).to(wanted).value;
  }

  d3.keys(gqueries).forEach(function(key) {
    var gquery = gqueries[key];
    var unit = gquery.unit;
    var base = unit.slice(-1);

    if (preferredUnits[base]) {
      transformed[key] = {
        present: transform(gquery.present, unit, preferredUnits[base]),
        future: transform(gquery.future, unit, preferredUnits[base]),
        unit: preferredUnits[base]
      };
    }
  });

  return transformed;
}
