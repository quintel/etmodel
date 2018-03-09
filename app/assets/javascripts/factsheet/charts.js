/* globals Quantity d3 */

(function() {
  var definitions = {
    demand: [
      {
        key: 'factsheet_energetic_final_demand_electricity',
        color: '#fbca36',
        icon: '/assets/factsheet/electricity.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_renewable_heat',
        color: '#eb5a3c',
        icon: '/assets/factsheet/renewable-heat.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_collective_heat',
        color: '#eb3138',
        icon: '/assets/factsheet/collective-heat.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_gas_other',
        color: '#3b73bf',
        icon: '/assets/factsheet/gas-other.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_gas_households_buildings',
        color: '#56aee4',
        icon: '/assets/factsheet/gas.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_bio_fuels',
        color: '#a55513',
        icon: '/assets/factsheet/wood.svg'
      },
      {
        key: 'factsheet_energetic_final_demand_oil_and_coal_products',
        color: '#82ca39',
        icon: '/assets/factsheet/oil.svg'
      }
    ],
    breakdown: [
      { key: 'factsheet_supply_heat_from_other', color: '#8c131d' },
      { key: 'factsheet_supply_heat_collective', color: '#a41824' },
      { key: 'factsheet_supply_heat_from_electricity', color: '#bc1a27' },
      { key: 'factsheet_supply_heat_from_biomass', color: '#e73133' },
      { key: 'factsheet_supply_heat_from_solar_thermal', color: '#eb5a3c' },

      { key: 'factsheet_supply_gas_from_synthetic_gas', color: '#2c3480' },
      { key: 'factsheet_supply_gas_from_biogas', color: '#2874b4' },
      { key: 'factsheet_supply_gas_from_fossil', color: '#56aee4' },

      { key: 'factsheet_supply_fossil_other', color: '#afafaf' },

      { key: 'factsheet_supply_electricity_from_other', color: '#e29028' },
      { key: 'factsheet_supply_electricity_from_wind', color: '#f4a540' },
      { key: 'factsheet_supply_electricity_from_solar', color: '#fbca36' },

      { key: 'factsheet_supply_biofuels', color: '#82ca39' }
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
        margin: { top: 10, right: 0, bottom: 25, left: 75 },
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
      margin: { top: 10, right: 0, bottom: 25, left: 75 },
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
