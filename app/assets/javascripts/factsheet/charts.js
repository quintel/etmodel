/* globals Quantity d3 */

(function() {
  var definitions = {
    demand: [
      {
        key: 'factsheet_energetic_final_demand_electricity',
        color: '#ffce05',
        icon: '/assets/factsheet/electricity.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_renewable_heat',
        color: '#eb5a3c',
        icon: '/assets/factsheet/renewable-heat.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_collective_heat',
        color: '#e7332a',
        icon: '/assets/factsheet/collective-heat.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_bio_fuels',
        color: '#a55513',
        icon: '/assets/factsheet/wood.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_gas_households_buildings',
        color: '#36a9e1',
        icon: '/assets/factsheet/gas.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_gas_other',
        color: '#3b73bf',
        icon: '/assets/factsheet/gas-other.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_oil_and_coal_products',
        color: '#95c11f',
        icon: '/assets/factsheet/transport.svg'
      }
    ],
    breakdown: [
      { key: 'factsheet_supply_electricity_from_wind',                  color: '#f39200' },
      { key: 'factsheet_supply_electricity_from_solar',                 color: '#f9b233' },
      { key: 'factsheet_supply_heat_from_rest_and_geothermal',          color: '#861612' },
      { key: 'factsheet_supply_heat_from_ambient',                      color: '#a61612' },
      { key: 'factsheet_supply_dry_biomass',                            color: '#e6332a' },
      { key: 'factsheet_supply_heat_from_solar_thermal',                color: '#ec6839' },
      { key: 'factsheet_supply_gas_from_synthetic_gas',                 color: '#2c3480' },
      { key: 'factsheet_supply_gas_from_biogas',                        color: '#1d71b8' },
      { key: 'factsheet_supply_gas_from_fossil',                        color: '#36a9e1' },
      { key: 'factsheet_supply_biofuels',                               color: '#82ca39' },
      { key: 'factsheet_supply_fossil_other',                           color: '#878787' }
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

  function valueFormatter(unit) {
    return function(value) {
      return new Quantity(value, unit).format();
    };
  }

  /**
   * Generic version of presentDemandChart and futureDemandChart.
   */
  function demandChart(gqueries, opts) {
    var max = Math.max(
      totalValue(gqueries, definitions.demand, 'future'),
      totalValue(gqueries, definitions.demand, 'present')
    );

    return Object.assign(
      {
        barPadding: 0.2,
        formatValue: opts.formatValue || valueFormatter(opts.unit),
        margin: { top: 10, right: 0, bottom: 24, left: 75 },
        max: max,
        series: chartSeriesFromRequest(
          gqueries,
          definitions.demand,
          opts.period
        )
      },
      opts
    );
  }

  /**
   * Renders a chart describing the present demand of the scenario.
   */
  function presentDemandChart(gqueries, unit) {
    return demandChart(gqueries, {
      drawLabels: false,
      period: 'present',
      title: gqueries.graph_year.present,
      unit: unit
    });
  }

  /**
   * Renders a chart describing the future demand of the scenario.
   */
  function futureDemandChart(gqueries, unit) {
    return demandChart(gqueries, {
      formatValue: function() {
        return '';
      },
      period: 'future',
      unit: unit,
      title: gqueries.graph_year.future,
      showY: false
    });
  }

  /**
   * Renders a chart describing individual demands for the future.
   */
  function futureDemandBreakdownChart(gqueries, unit) {
    return {
      formatValue: valueFormatter(unit),
      margin: { top: 10, right: 0, bottom: 24, left: 75 },
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
