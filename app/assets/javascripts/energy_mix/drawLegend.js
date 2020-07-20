/* globals I18n $ */

/**
 * Given the definition for a chart, returns an array of <div/> elements
 * describing each series in the chart.
 */
function drawLegend(definition, periods) {
  var showPeriods = periods || ['future'];

  var list = definition.map(function(series) {
    var key = series.key.replace(/_/g, '-');

    return $('<div class="legend-row" />')
      .addClass(key)
      .append(
        $('<span class="key"/>').append(
          $('<span class="legend-item" />').css(
            'background-color',
            series.color
          ),
          ' ',
          I18n.t('energy_mix.series.' + series.key)
        ),
        showPeriods.map(function(period) {
          return $('<span class="value" />')
            .attr('data-query', series.key)
            .attr('data-no-unit', true)
            .attr('data-period', period)
            .html('&mdash;');
        })
      );
  });

  list.reverse();

  return list;
}
