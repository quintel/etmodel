/* globals I18n $ */

/**
 * Given the definition for a chart, returns an array of <div/> elements
 * describing each series in the chart.
 */
function drawLegend(definition) {
  var list = definition.map(function(series) {
    return $('<tr/>').append(
      $('<td class="key"/>').append(
        $('<span class="legend-item" />').css('background-color', series.color),
        ' ',
        I18n.t('factsheet.series.' + series.key)
      ),
      $('<td class="value" />')
        .attr('data-query', series.key)
        .attr('data-as', 'TJ')
        .attr('data-no-unit', true)
        .html('&mdash;')
    );
  });

  list.reverse();

  return list;
}
