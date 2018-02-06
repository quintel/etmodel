/* globals formatQueryResult stackedBarChart d3 Quantity I18n */

//= require d3.v2
//= require lib/models/metric
//= require lib/models/quantity
//= require factsheet/formatValue
//= require factsheet/stackedBarChart
//= require factsheet/charts

/**
 * Given the full list of charts which will be displayed, extracts the queries
 * needed.
 */
function queriesFromCharts(allSeries) {
  var queries = d3.values(allSeries).map(function(series) {
    return series.map(function(serie) {
      return serie.key;
    });
  });

  return [].concat.apply([], queries);
}

/**
 * Given a DOM element, recurses through all child elements with a data-query
 * attribute, and extracts the full list of queries needed to render the tree.
 */
function queriesFromElement(element) {
  var queries = [];

  $('[data-query]', element).each(function(index, el) {
    queries.push(el.dataset.query);
  });

  return queries;
}

/**
 * Given a DOM element, recurses through all children assigning formatted query
 * values to nodes which have a data-query attribute.
 */
function assignQueryValues(element, values) {
  $('[data-query]', element).each(function(index, node) {
    var el = $(node);
    var data = values[el.data('query')];

    el.text(formatQueryResult(data, el.data()));
  });
}

/**
 * Transforms the queries returned by ETEngine so that any query expressing a
 * value in some amount of joules (TJ, PJ, etc) is converted to MJ.
 */
function transformGqueries(gqueries) {
  var transformed = Object.assign({}, gqueries);

  d3.keys(gqueries).forEach(function(key) {
    var gquery = gqueries[key];
    var unit = gquery.unit;

    if (unit && unit !== 'MJ' && unit.match(/^\wJ$/)) {
      // Energy; convert to MJ.
      transformed[key] = {
        present: new Quantity(gquery.present, unit).to('MJ').value,
        future: new Quantity(gquery.future, unit).to('MJ').value,
        unit: 'MJ'
      };
    }
  });

  return transformed;
}

jQuery(function() {
  var request;
  var queries;

  var url = window.factsheetSettings.endpoint;
  var individualDemandLegendEl = $('#individual-demand .legend tbody');

  // draw individual demand legend
  window.charts.definitions.breakdown.forEach(function(series) {
    individualDemandLegendEl.prepend(
      $('<tr/>').append(
        $('<td class="key"/>').append(
          $('<span class="legend-item" />').css(
            'background-color',
            series.color
          ),
          ' ',
          I18n.t('factsheet.series.' + series.key)
        ),
        $('<td class="value" />')
          .attr('data-query', series.key)
          .attr('data-as', 'TJ')
          .attr('data-no-unit', true)
          .html('&mdash;')
      )
    );
  });

  queries = queriesFromElement(document).concat(
    queriesFromCharts(window.charts.definitions)
  );

  request = $.ajax({
    type: 'PUT',
    url: url,
    data: { gqueries: queries },
    dataType: 'json'
  });

  request.done(function(response) {
    var gqueries = transformGqueries(response.gqueries);

    if (response.scenario.title && response.scenario.title !== 'API') {
      $('#title').append($('<h2/>').text(response.scenario.title));
    }

    assignQueryValues(document, gqueries);

    // Must show the factsheet prior to rendering the charts to get accurate
    // element sizes for the charts.
    $('#factsheet-pending').remove();
    $('#factsheet-content').show();

    stackedBarChart(
      '#present .chart',
      window.charts.presentDemandChart(gqueries)
    );

    stackedBarChart(
      '#aggregate-demand .chart',
      window.charts.futureDemandChart(gqueries)
    );

    stackedBarChart(
      '#individual-demand .chart',
      window.charts.futureDemandBreakdownChart(gqueries)
    );
  });

  request.fail(function(error) {
    var messages = _.uniq(error.responseJSON.errors.sort()).map(function(
      message
    ) {
      return $('<li/>').text(message);
    });

    $('#factsheet-pending .loading').remove();

    $('<div class="errors" />')
      .append('<h4>Oops!</h4>', $('<ul />').append(messages))
      .appendTo($('#factsheet-pending'));
  });
});
