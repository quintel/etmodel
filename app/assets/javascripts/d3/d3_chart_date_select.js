/* globals $ App d3 I18n */

var D3ChartDateSelect = (function() {
  'use strict';

  var epoch = new Date(0),
    msInWeek = 604800000;

  function buildOption(i) {
    var nextIndex = i + 1,
      msOffset = msInWeek * i,
      start = new Date(epoch.getDate() + msOffset),
      end = new Date(start.getDate() + msOffset + msInWeek);

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
    weeks: [[epoch, new Date(1970, 11, 30, 23)]],

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
