EstablishmentShot.Charts = (function () {
    'use strict';

    var colors = [
            '#26b01f', // green
            '#ffcf28', // yellow
            '#009cff', // blue
            '#ff2600', // red
            '#3cd9c8', // greenblue
            '#e166ce', // purple
        ],
        smallChartDefaults = {
            type: EstablishmentShot.BarChart,
            width: 150,
            height: 188,
            color_gradient: colors,
            margin: {
                top: 10,
                right: 0,
                bottom: 25,
                left: 50
            }
        };

    return {
        charts: {
            bar_chart: {
                width: 150,
                height: 419,
                margin: {
                    top: 10,
                    right: 0,
                    bottom: 25,
                    left: 60
                },
                color_gradient: colors,
                type: EstablishmentShot.BarChart,
                series: [
                    { key: 'co2_sheet_agriculture_total_co2_emissions' },
                    { key: 'co2_sheet_industry_energy_total_co2_emissions' },
                    { key: 'co2_sheet_transport_total_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_total_co2_emissions' }
                ]
            },
            bar_chart_buildings: $.extend({
                series: [
                    { key: 'co2_sheet_buildings_households_space_heating_cooling_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_hot_water_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_cooking_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_appliances_light_co2_emissions' }
                ]
            }, smallChartDefaults),
            bar_chart_industry: $.extend({
                series: [
                    { key: 'co2_sheet_industry_metal_co2_emissions' },
                    { key: 'co2_sheet_industry_chemical_co2_emissions' },
                    { key: 'co2_sheet_industry_food_co2_emissions' },
                    { key: 'co2_sheet_industry_paper_co2_emissions' },
                    { key: 'co2_sheet_energy_sector_total_co2_emissions' },
                    { key: 'co2_sheet_industry_other_co2_emissions' }
                ]
            }, smallChartDefaults),
            bar_chart_agriculture: $.extend({
                series: [
                    { key: 'co2_sheet_agriculture_heat_co2_emissions' },
                    { key: 'co2_sheet_agriculture_power_and_light_co2_emissions' }
                ]
            }, smallChartDefaults),
            bar_chart_transport: $.extend({
                series: [
                    { key: 'co2_sheet_transport_car_co2_emissions' },
                    { key: 'co2_sheet_transport_busses_co2_emissions' },
                    { key: 'co2_sheet_transport_trains_co2_emissions' },
                    { key: 'co2_sheet_transport_trucks_co2_emissions' },
                    { key: 'co2_sheet_transport_ships_co2_emissions' }
                ]
            }, smallChartDefaults)
        },
        getQueries: function () {
            var chart,
                queries = [];

            for (chart in this.charts) {
                this.charts[chart].series.forEach(function (serie) {
                    queries.push(serie.key);
                });
            }

            return queries;
        }
    }
}());
