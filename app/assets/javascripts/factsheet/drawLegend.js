/* globals I18n $ */

/**
 * Given the definition for a chart, returns an array of <div/> elements
 * describing each series in the chart.
 */
function drawLegend(definition, periods) {
  var showPeriods = periods || ['future'];

  var list = definition.map(function(series) {
    var key = series.key.replace(/_/g, '-');

    return $('<tr/>')
      .addClass(key)
      .append(
        $('<td class="key"/>').append(
          $('<span class="legend-item" />').css(
            'background-color',
            series.color
          ),
          ' ',
          I18n.t('factsheet.series.' + series.key)
        ),
        showPeriods.map(function(period) {
          return $('<td class="value" />')
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
