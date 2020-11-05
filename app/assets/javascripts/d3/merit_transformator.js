/* globals d3 */

var MeritTransformator = (function() {
  'use strict';

  function downsampleFunc(name) {
    if (typeof name === 'function') {
      return name;
    }

    return d3[name || 'mean'];
  }

  return {
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
          downsampleFunc(downsampleWith).call(null, values.slice(day * 24, (day + 1) * 24))
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
