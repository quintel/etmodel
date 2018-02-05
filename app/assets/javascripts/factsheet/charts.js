/* globals Quantity Metric d3 */

(function () {
  var definitions = {
    demand: [
      { key: 'total_electricity_produced', color: '#fbca36' },
      { key: 'factsheet_demand_of_collective_heat', color: '#eb3138' },
      {
        key: 'factsheet_demand_of_gas_in_industry_agriculture_other',
        color: '#3b73bf'
      },
      {
        key: 'factsheet_demand_of_gas_in_households_and_buildings',
        color: '#56aee4'
      },
      { key: 'factsheet_demand_of_gasoline_diesel_lpg', color: '#82ca39' }
    ],
    breakdown: [
      {
        key: 'factsheet_electricity_not_from_wind_and_solar',
        color: '#da871c'
      },
      { key: 'electricity_produced_from_wind', color: '#f4a540' },
      { key: 'electricity_produced_from_solar', color: '#fbca36' },
      { key: 'factsheet_demand_of_collective_heat', color: '#eb3138' },
      {
        key: 'factsheet_demand_of_gas_in_industry_agriculture_other',
        color: '#3b73bf'
      },
      {
        key: 'factsheet_demand_of_gas_in_households_and_buildings',
        color: '#56aee4'
      },
      { key: 'factsheet_demand_of_gasoline_diesel_lpg', color: '#82ca39' }
    ]
  };

  function valueScaler(gqueries, series, period) {
    var unit = gqueries[series[0].key].unit;

    var max = d3.max(series, function (serie) {
      return gqueries[serie.key][period];
    });

    if (Quantity.isSupported(unit)) {
      return Quantity.scaleAndFormatBy(max, unit, {});
    }

    return function (value) {
      return Metric.autoscale_value(value, unit, 2, false);
    };
  }

  function chartSeriesFromRequest(gqueries, series, period) {
    // Create a unit scaler.
    return series.map(function (serie) {
      return $.extend({}, serie, {
        value: gqueries[serie.key][period]
      });
    });
  }

  /**
   * Generic version of presentDemandChart and futureDemandChart.
   */
  function demandChart(gqueries, period) {
    var scale = valueScaler(gqueries, definitions.demand, period);

    return {
      title: 'Energievraag',
      formatValue: scale,
      series: chartSeriesFromRequest(gqueries, definitions.demand, period)
    };
  }

  /**
   * Renders a chart describing the present demand of the scenario.
   */
  function presentDemandChart(gqueries) {
    return demandChart(gqueries, 'present');
  }

  /**
   * Renders a chart describing the future demand of the scenario.
   */
  function futureDemandChart(gqueries) {
    return demandChart(gqueries, 'future');
  }

  /**
   * Renders a chart describing individual demands for the future.
   */
  function futureDemandBreakdownChart(gqueries) {
    return {
      title: 'Energieaanbod',
      formatValue: function () {
        return '';
      },
      margin: { top: 10, right: 0, bottom: 25, left: 5 },
      series: chartSeriesFromRequest(gqueries, definitions.breakdown, 'future')
    };
  }

  window.charts = {
    presentDemandChart: presentDemandChart,
    futureDemandChart: futureDemandChart,
    futureDemandBreakdownChart: futureDemandBreakdownChart,
    definitions: definitions
  };
}());
