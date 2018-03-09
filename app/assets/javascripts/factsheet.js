/* globals formatQueryResult preferredUnits stackedBarChart d3 transformGqueries drawLegend */

//= require d3.v2
//= require lib/models/metric
//= require lib/models/quantity
//= require factsheet/preferredUnits
//= require factsheet/transformGqueries
//= require factsheet/formatValue
//= require factsheet/stackedBarChart
//= require factsheet/charts
//= require factsheet/drawLegend

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

jQuery(function() {
  var request;
  var queries = ['graph_year'];

  var url = window.factsheetSettings.endpoint;

  $('#summary .legend tbody').append(
    drawLegend(window.charts.definitions.demand, ['present', 'future'])
  );

  $('#carrier-use .legend tbody').append(
    drawLegend(window.charts.definitions.breakdown)
  );

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
    var units = preferredUnits(response.gqueries);
    var gqueries = transformGqueries(response.gqueries, units);

    if (response.scenario.title && response.scenario.title !== 'API') {
      $('#title').append($('<h2/>').text(response.scenario.title));
    }

    assignQueryValues(document, gqueries);

    // Must show the factsheet prior to rendering the charts to get accurate
    // element sizes for the charts.
    $('#factsheet-pending').remove();
    $('#factsheet-content').show();

    stackedBarChart(
      '#summary .chart.present',
      window.charts.presentDemandChart(gqueries, units.J)
    );

    stackedBarChart(
      '#summary .chart.future',
      window.charts.futureDemandChart(gqueries, units.J)
    );

    stackedBarChart(
      '#carrier-use .chart',
      window.charts.futureDemandBreakdownChart(gqueries, units.J)
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
