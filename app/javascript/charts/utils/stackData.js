import { group, stack } from 'd3';

/**
 * Receives the data from `stackData` and returns an array containing all the unique id values.
 */
const idsFromData = data => Array.from(new Set(data.map(d => d.id)));

// Transform the grouped values into an array of objects, where each object describes the data
// for each column, without extra maps and arrays around values. g[0] is the x value (year),
// and g[1] contains the map of each gquery key and value.

/**
 * Takes data grouped by d3.group and produces a simpler "table" version. Whereas the value returned
 * by d3.group is a map of x values to gqueries, gquery values are wrapped in arrays and each object
 * lacks the "x" value. Removing the array wrapper and adding "x" simplifies use of the data in the
 * D3 chart.
 *
 * @param {Map} grouped The grouped data from d3.group.
 * @param {string[]} keys The gquery keys to be included in the table.
 *
 * @return {object[]}
 *
 * @example
 *   const grouped = someData;
 *   // Map {
 *   //   2015 => Map { gquery_one => SerieData, gquery_two => SerieData },
 *   //   2050 => Map { gquery_one => SerieData, gquery_two => SerieData },
 *   // }
 *
 *   toTable(grouped, ['gquery_one', 'gquery_two'])
 *   // [
 *   //   { x: 2015, gquery_one: 1.0, gquery_two: 2.0 },
 *   //   { x: 2050, gquery_one: 3.0, gquery_two: 4.0 }
 *   // ]
 */
const toTable = (grouped, keys) => {
  return Array.from(grouped.entries()).map(g => {
    // g[0] is the x value (year) and g[1] contains a map of each gquery key and serie data wrapped
    // in an array.
    const column = { x: g[0] };

    for (let serieKey of keys) {
      if (g[1].has(serieKey)) {
        column[serieKey] = g[1].get(serieKey)[0].y;
      } else {
        column[serieKey] = 0;
      }
    }

    return column;
  });
};

/**
 * Receives an array of objects, describing individual values to be shown on a chart, groups them
 * according to their "x" value (typically year) and stacks the values.
 *
 * @param {array} data
 *   An array of data points; each one an object containing `x`, `y`, and `id`. `x` and `y` are
 *   their x and y values respectively, while `id` is a string representing the series name. The
 *   same `id` may be used multiple times (typically with a different `x`).
 * @param {function} stackFunc
 *   A function used to stack values. This defaults to `d3.stack()`. Customise the stack options by
 *   padding a custom function.
 *
 * @example
 *   stackData(
 *     [{ x: 0, y: 10, id: 'a' }, { x: 0, y: 3, id: 'b'}, { x: 1, y: 5, id: 'a'}],
 *     d3.stack.offset(d3.stackOffsetDiverging)
 *   );
 */
export default (data, stackFunc = stack()) => {
  // Group the data based on the year ("x") and then key the values by the gquery key ("id").
  //
  // Produces a Map like:
  //
  //    Map {
  //      2015 => Map { gquery_one => SerieData, gquery_two => SerieData },
  //      2050 => Map { gquery_one => SerieData, gquery_two => SerieData },
  //    }
  //
  // ... where `SerieData` is data about a series returned by `prepareData`.
  const grouped = group(
    data,
    d => d.x,
    d => d.id
  );

  const keys = idsFromData(data);

  // Stack values. This produces an array containing values for each series, in each column.
  const stacked = stackFunc.keys(keys)(toTable(grouped, keys));

  // Add some useful inforamtion about the series to each value.
  return stacked.map(d => {
    d.forEach(v => (v.key = d.key));
    return d;
  });
};
