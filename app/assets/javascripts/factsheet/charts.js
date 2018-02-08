/* globals Quantity d3 */

(function() {
  var definitions = {
    demand: [
      {
        key: 'final_demand_of_electricity',
        color: '#fbca36',
        icon: '/assets/factsheet/electricity.svg'
      },
      {
        key: 'factsheet_demand_of_collective_heat',
        color: '#eb3138',
        icon: '/assets/factsheet/heat.svg'
      },
      {
        key: 'factsheet_demand_of_gas_in_industry_agriculture_other',
        color: '#3b73bf',
        icon: '/assets/factsheet/gas.svg'
      },
      {
        key: 'factsheet_demand_of_gas_in_households_and_buildings',
        color: '#56aee4',
        icon: '/assets/factsheet/gas.svg'
      },
      {
        key: 'factsheet_demand_of_gasoline_diesel_lpg',
        color: '#82ca39',
        icon: '/assets/factsheet/oil.svg'
      }
    ],
    futureDemand: [
      {
        key: 'factsheet_demand_of_electricity_future',
        color: '#fbca36',
        icon: '/assets/factsheet/electricity.svg'
      },
      {
        key: 'factsheet_demand_of_heat_total',
        color: '#eb3138',
        icon: '/assets/factsheet/heat.svg'
      },
      {
        key: 'factsheet_demand_of_gas_total',
        color: '#56aee4',
        icon: '/assets/factsheet/gas.svg'
      },
      {
        key: 'factsheet_demand_of_biomass_transport',
        color: '#82ca39',
        icon: '/assets/factsheet/oil.svg'
      }
    ],
    breakdown: [
      { key: 'electricity_produced_from_wind', color: '#f4a540' },
      { key: 'electricity_produced_from_solar', color: '#fbca36' },
      { key: 'factsheet_demand_of_collective_heat', color: '#a41824' },
      {
        key: 'factsheet_demand_of_individual_heat_all_electric',
        color: '#bc1a27'
      },
      {
        key: 'factsheet_demand_of_biomass_in_households_and_buildings',
        color: '#e73133'
      },
      {
        key: 'factsheet_demand_of_water_heater_solar_thermal',
        color: '#eb5a3c'
      },
      {
        key: 'final_demand_of_hydrogen_in_transport',
        color: '#2c3480'
      },
      {
        key: 'factsheet_demand_of_greengas',
        color: '#2874b4'
      },
      {
        key: 'factsheet_demand_of_natural_gas',
        color: '#56aee4'
      },
      { key: 'factsheet_demand_of_biomass_transport', color: '#82ca39' }
    ]
  };

  function totalValue(gqueries, series, period) {
    return d3.sum(series, function(serie) {
      return gqueries[serie.key][period];
    });
  }

  function chartSeriesFromRequest(gqueries, series, period) {
    // Create a unit scaler.
    return series.map(function(serie) {
      return $.extend({}, serie, {
        value: gqueries[serie.key][period]
      });
    });
  }

  /**
   * Generic version of presentDemandChart and futureDemandChart.
   */
  function demandChart(gqueries, opts) {
    var scale = function(value) {
      return new Quantity(value, opts.unit).format();
    };

    return {
      title: 'Energievraag',
      formatValue: scale,
      series: chartSeriesFromRequest(gqueries, opts.definition, opts.period),
      margin: {
        top: 10,
        right: 0,
        bottom: 25,
        left: 75
      },
      drawLabels: opts.drawLabels
    };
  }

  /**
   * Renders a chart describing the present demand of the scenario.
   */
  function presentDemandChart(gqueries, unit) {
    return demandChart(gqueries, {
      period: 'present',
      definition: definitions.demand,
      unit: unit,
      drawLabels: false
    });
  }

  /**
   * Renders a chart describing the future demand of the scenario.
   */
  function futureDemandChart(gqueries, unit) {
    return demandChart(gqueries, {
      period: 'future',
      definition: definitions.futureDemand,
      unit: unit,
      drawLabels: true
    });
  }

  /**
   * Renders a chart describing individual demands for the future.
   */
  function futureDemandBreakdownChart(gqueries) {
    var max = totalValue(gqueries, definitions.futureDemand, 'future');

    return {
      title: 'Energieaanbod',
      formatValue: function() {
        return '';
      },
      max: max,
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
})();
