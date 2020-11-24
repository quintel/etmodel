import type { Stack, SeriesPoint } from 'd3-shape';

import { stack } from 'd3-shape';
import { group, groups } from 'd3-array';

// Data provided by a chart which will be stacked.
interface InputData {
  x: number;
  y: number;
  id: string;
  key?: string;
}

// Data which may first be split into separate groups (defined by the stackKey) and then stacked.
interface GroupableInputData extends InputData {
  groupKey: string;
}

/**
 * toTable converts an array of InputData into TableData. TableData has an x value, representing the
 * x position in the chart, and zero or more keys mapping gquery keys to their values at the
 * corresponding x value.
 */
interface TableData {
  x: number;
  key?: string;
  [k: string]: number | string;
}

type StackFunction = Stack<unknown, TableData, string>;
type StackResult = ReturnType<StackFunction>;

// Extends the D3 SeriesPoint to allow us to assign the series key onto the returned data.
interface KeyedSeriesPoint extends SeriesPoint<TableData> {
  key: string;
}

/**
 * Receives the data from `stackData` and returns an array containing all the unique id values.
 */
const idsFromData = (data: { id: string }[]): string[] =>
  // Targetting ES5 means no [...new Set], and enabling downlevelIteration in TypeScript won't work
  // as IE11 has no Symbol.iterator.
  // eslint-disable-next-line unicorn/prefer-spread
  Array.from(new Set(data.map((d) => d.id)));

// Transform the grouped values into an array of objects, where each object describes the data
// for each column, without extra maps and arrays around values. g[0] is the x value (year),
// and g[1] contains the map of each gquery key and value.

/**
 * Takes data grouped by d3.group and produces a simpler "table" version. Whereas the value returned
 * by d3.group is a map of x values to gqueries, gquery values are wrapped in arrays and each object
 * lacks the "x" value. Removing the array wrapper and adding "x" simplifies use of the data in the
 * D3 chart.
 *
 * @param grouped The grouped data from d3.group.
 * @param keys The gquery keys to be included in the table.
 *
 * @example
 *   const grouped = someData;
 *   // Map {
 *   //   2015 => Map { gquery_one => [InputData], gquery_two => [InputData] },
 *   //   2050 => Map { gquery_one => [InputData], gquery_two => [InputData] },
 *   // }
 *
 *   toTable(grouped, ['gquery_one', 'gquery_two'])
 *   // [
 *   //   { x: 2015, gquery_one: 1.0, gquery_two: 2.0 },
 *   //   { x: 2050, gquery_one: 3.0, gquery_two: 4.0 }
 *   // ]
 */
const toTable = (grouped: Map<number, Map<string, InputData[]>>, keys: string[]): TableData[] => {
  // eslint-disable-next-line unicorn/prefer-spread
  return Array.from(grouped.entries()).map((g) => {
    // g[0] is the x value (year) and g[1] contains a map of each gquery key and serie data wrapped
    // in an array.
    const column = { x: g[0] };

    for (const serieKey of keys) {
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
 * @param data
 *   An array of data points; each one an object containing `x`, `y`, and `id`. `x` and `y` are
 *   their x and y values respectively, while `id` is a string representing the series name. The
 *   same `id` may be used multiple times (typically with a different `x`).
 * @param stackFunc
 *   A function used to stack values. This defaults to `d3.stack()`. Customise the stack options by
 *   padding a custom function.
 *
 * @example
 *   stackData(
 *     [{ x: 0, y: 10, id: 'a' }, { x: 0, y: 3, id: 'b' }, { x: 1, y: 5, id: 'a' }],
 *     d3.stack.offset(d3.stackOffsetDiverging)
 *   );
 */
const stackData = (
  data: InputData[],
  stackFunc: StackFunction = stack<TableData>()
): StackResult => {
  // Group the data based on the year ("x") and then key the values by the gquery key ("id").
  //
  // Produces a Map like:
  //
  //    Map {
  //      2015 => Map { gquery_one => InputData, gquery_two => InputData },
  //      2050 => Map { gquery_one => InputData, gquery_two => InputData },
  //    }
  //
  // ... where `InputData` is data about a series returned by `prepareData`.
  const grouped = group(
    data,
    (d) => d.x,
    (d) => d.id
  );

  const keys = idsFromData(data);

  // Stack values. This produces an array containing values for each series, in each column.
  const stacked = stackFunc.keys(keys)(toTable(grouped, keys));

  // Add some useful inforamtion about the series to each value.
  return stacked.map((d) => {
    d.forEach((v) => ((v as KeyedSeriesPoint).key = d.key));
    return d;
  });
};

/**
 * Receives an array of objects, describing individual values to be shown on a chart, groups them
 * according to their "groupKey" value, and then passes each group separately to `stackData` to be
 * stacked.
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
 *     [
 *       { x: 0, y: 6, id: 'a', groupKey: 'jan' },
 *       { x: 0, y: 3, id: 'b', groupKey: 'jan' },
 *       { x: 1, y: 5, id: 'a', groupKey: 'feb' }
 *     ],
 *     d3.stack.offset(d3.stackOffsetDiverging)
 *   );
 */
export const groupedStack = (
  data: GroupableInputData[],
  stackFunc: StackFunction = stack<TableData>()
): StackResult[] => {
  return groups(data, (d) => d.groupKey).map(([, groupData]) => {
    return stackData(groupData, stackFunc);
  });
};

export default stackData;
