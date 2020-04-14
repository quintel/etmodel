/* globals $ App d3 I18n */

var D3ChartDateSelect = (function() {
  'use strict';

  var msInHour = 60 * 60 * 1000;
  var epoch = new Date(0);
  var msInWeek = msInHour * 24 * 7;

  function buildOption(i) {
    var nextIndex = i + 1;
    var msOffset = msInWeek * i;
    var start = new Date(epoch.getDate() + msOffset);

    // Remove an hour from the end of the range to as the range should be 00:00
    // to 23:00, not 00:00 to 00:00.
    var end = new Date(start.getDate() + msOffset + msInWeek - msInHour);

    this.weeks[nextIndex] = [start, end];

    return (
      '<option value="' +
      nextIndex +
      '">' +
      optionText(start, end) +
      '</option>'
    );
  }

  function optionText(start, end) {
    return (
      I18n.strftime(start, '%-d %b') + ' - ' + I18n.strftime(end, '%-d %b')
    );
  }

  function createOptions(downsampleMethod) {
    var textNamespace = 'output_elements.common.';

    var yearText = I18n.t(
      textNamespace + 'whole_year_daily_' + downsampleMethod,
      {
        defaultValue: I18n.t(textNamespace + 'whole_year')
      }
    );

    var options = '<option value="0">' + yearText + '</option>';

    for (var i = 0; i < 52; i += 1) {
      options += buildOption.call(this, i);
    }

    return options;
  }

  function updateMeritChartsDate(s, val) {
    this.selectBox.val(val);
    this.updateChart && this.updateChart();
  }

  function setMeritChartsDate() {
    App.settings.set('merit_charts_date', $(this).val());
  }

  function buildSelectBox(downsampleMethod) {
    return $('<select/>')
      .addClass('d3-chart-date-select')
      .append(createOptions.call(this, downsampleMethod))
      .val(App.settings.get('merit_charts_date') || '0')
      .on('change', setMeritChartsDate);
  }

  D3ChartDateSelect.prototype = {
    selectBox: undefined,
    weeks: [[epoch, new Date(1970, 11, 31, 1)]],

    draw: function(updateChart) {
      this.updateChart = updateChart;
      this.selectBox = buildSelectBox.call(this, this.downsampleMethod);

      this.scope.append(this.selectBox);

      App.settings.on(
        'change:merit_charts_date',
        updateMeritChartsDate.bind(this)
      );
    },

    getCurrentRange: function() {
      return this.weeks[this.val()];
    },

    /**
     * Returns an array of dates which should be shown in the time axis, based
     * on the currently-selected week.
     */
    tickValues: function() {
      var values = [];

      if (this.isWeekly()) {
        var startDate = this.weeks[this.val()][0];
        var msInDay = 1000 * 60 * 60 * 24;

        for (var i = 0; i < 7; i++) {
          values.push(new Date(startDate.getTime() + msInDay * i));
        }
      } else {
        for (var j = 0; j < 12; j++) {
          values.push(new Date(Date.UTC(1970, j, 1)));
        }
      }

      return values;
    },

    val: function() {
      return parseInt(this.selectBox.val(), 10);
    },

    isWeekly: function() {
      return this.val() > 0;
    }
  };

  function D3ChartDateSelect(scope, range, downsampleMethod) {
    this.scope = $(scope);
    this.range = range;
    this.downsampleMethod = downsampleMethod;
  }

  return D3ChartDateSelect;
})();
