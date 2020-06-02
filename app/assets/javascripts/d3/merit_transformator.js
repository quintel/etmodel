/* globals d3 */

// eslint-disable-next-line no-unused-vars
var MeritTransformator = (function() {
  'use strict';

  function downsampleFunc(name) {
    if (typeof name === 'function') {
      return name;
    }

    return d3[name || 'mean'];
  }

  /**
   * Returns the index of the maximum value in the array of values.
   */
  function indexOfMax(values) {
    var index = 0;
    var max = values[0];

    for (var i = 1; i < values.length; i++) {
      if (values[i] > max) {
        max = values[i];
        index = i;
      }
    }

    return index;
  }

  /**
   * Sums a two-dimensional array of values from one or more series.
   *
   * @example Summing two arrays
   *
   *   sumMatrix([
   *     [1, 2, 3],
   *     [10, 20, 30]
   *   ])
   *   // => [11, 22, 33]
   */
  function sumMatrix(matrix) {
    var sums = matrix[0].slice();

    for (var row = 1; row < matrix.length; row++) {
      var line = matrix[row];

      for (var col = 0; col < line.length; col++) {
        sums[col] = (sums[col] || 0) + (line[col] || 0);
      }
    }

    return sums;
  }

  /**
   * Takes values from multiple series and downsamples to return the maximum
   * daily load.
   *
   * This is different to using `downsampleWith: 'max'` on each individual
   * series: that method selects the maximum value of each series, no matter
   * which hour that occurs in (series 1 may be hour 0, series 2 may be hour 12,
   * etc). `downsampleCumulativeMax` finds the hour in each day where there is
   * the largest cumulative load, then returns the loads for each series in that
   * hour.
   *
   * @param {Array[Array[number]]} series
   *   An array of arrays. Each subarray contains all 8760 values for the year
   *   for each series.
   *
   * @return {Array}
   *   Returns an array of arrays. Contains the same number of arrays as the
   *   input, in the same order.
   */
  function downsampleCumulativeMax(series) {
    var sampled = [];

    var weekSlices;
    var hourlyMax;
    var allSame;
    var index;

    for (var day = 0; day < 365; day++) {
      // Create an array where each value is an array of values from each
      // series, for each hour in the current week.
      weekSlices = series.map(function(serieValues) {
        return serieValues.slice(day * 24, (day + 1) * 24);
      });

      // Create the array of hourly sums for the current week.
      hourlyMax = sumMatrix(weekSlices);

      allSame = hourlyMax.every(function(value) {
        return value !== hourlyMax[0];
      });

      // When the day peak load is flat, we sample loads from mid-day.
      index = 11;

      if (!allSame) {
        index = indexOfMax(hourlyMax);
      }

      weekSlices.map(function(serieValues, serieIndex) {
        sampled[serieIndex] = sampled[serieIndex] || [];
        sampled[serieIndex].push(serieValues[index]);
      });
    }

    return sampled;
  }

  return {
    /**
     * Samples multiple series.
     *
     * @param {Array[Array[number]]} series
     *   An array of arrays; each subarray contains the full 8760 values from
     *   each series to be downsampled.
     * @param {number} weekNum
     *   The week number to be sampled. If a number is present, the loads for
     *   that week are extracted from `series` without any further sampling.
     * @param {String} downsampleWith
     *   When `weekNum` is 0, the full yearly values are downsamples either
     *   using "mean" (get the mean value per day) or "max" (find the peak hour
     *   in the day and extract the load for each series in that hour).
     *
     * @return {Array[Array[number]]}
     *   Returns downsamples values for each series, in the same order as the
     *   `series` argument.
     */
    transformMany: function(series, weekNum, downsampleWith) {
      if (weekNum || downsampleWith !== 'max') {
        return series.map(function(values) {
          return MeritTransformator.transform(values, weekNum, downsampleWith);
        });
      }

      return downsampleCumulativeMax(series);
    },

    transform: function(values, weekNum, downsampleWith) {
      if (weekNum) {
        return this.sliceValues(values, weekNum);
      }

      return this.downsample(values, downsampleWith);
    },

    /**
     * Given an array of values representing samples of annual data,
     * produces a downsampled version with each new value representing the
     * mean for each day.
     *
     * @param  {array} values Array of values to downsample.
     */
    downsample: function(values, downsampleWith) {
      var result = [];
      var day;

      for (day = 0; day < 365; day += 1) {
        result.push(
          downsampleFunc(downsampleWith).call(
            null,
            values.slice(day * 24, (day + 1) * 24)
          )
        );
      }

      return result;
    },

    /**
     * Given an array of values representing samples of annual data, one for
     * each hours, produces the data for the weekNum.
     *
     * @param  {array}  values  Array of values.
     * @param  {number} weekNum Number of the week to extract. Jan 1-7: 1,
     *                          Jan 8-14: 2, etc.
     */
    sliceValues: function(values, weekNum) {
      var weekLen = Math.floor(values.length / 365) * 7;
      return values.slice((weekNum - 1) * weekLen, weekNum * weekLen);
    }
  };
})();
