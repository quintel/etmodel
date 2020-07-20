/*
 globals formatQueryResult preferredUnits stackedBarChart d3 transformGqueries drawLegend I18n $
 */

//= require d3.v2
//= require lib/models/metric
//= require lib/models/quantity
//= require energy_mix/preferredUnits
//= require energy_mix/transformGqueries
//= require energy_mix/formatValue
//= require energy_mix/stackedBarChart
//= require energy_mix/charts
//= require energy_mix/drawLegend

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

  var url = window.energyMixSettings.endpoint;

  I18n.translations[I18n.currentLocale()].number = {
    format: { separator: ',', delimiter: '.' }
  };

  $('#summary .legend .items').append(
    drawLegend(window.charts.definitions.demand, ['present', 'future'])
  );

  $('#carrier-use .legend .items').append(
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

    assignQueryValues(document, gqueries);

    // Must show the energy-mix prior to rendering the charts to get accurate
    // element sizes for the charts.
    $('#energy-mix-pending').remove();
    $('#energy-mix-content, #energy-mix-reverse').show();

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

    $('#energy-mix-pending .loading').remove();

    $('<div class="errors" />')
      .append('<h4>Oops!</h4>', $('<ul />').append(messages))
      .appendTo($('#energy-mix-pending'));
  });

  $('#disclaimer button').on('click', function() {
    // Fade out but leave in place to avoid the page jumping.
    $('#disclaimer').animate({ opacity: 0 });
  });
});
