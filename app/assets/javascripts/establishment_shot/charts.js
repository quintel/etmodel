EstablishmentShot.Charts = (function () {
    'use strict';

    var smallChartDefaults = {
        type: EstablishmentShot.BarChart,
        width: 150,
        height: 188,
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
                type: EstablishmentShot.BarChart,
                series: [
                    { key: 'co2_sheet_agriculture_total_co2_emissions', color: '#75B159' },
                    { key: 'co2_sheet_industry_energy_total_co2_emissions', color: '#FFFF00' },
                    { key: 'co2_sheet_transport_total_co2_emissions', color: '#125FD2' },
                    { key: 'co2_sheet_buildings_households_total_co2_emissions', color: '#FF2600' }
                ]
            },
            bar_chart_buildings: $.extend({
                series: [
                    { key: 'co2_sheet_buildings_households_space_heating_cooling_co2_emissions', color: '#f4cccc' },
                    { key: 'co2_sheet_buildings_households_hot_water_co2_emissions', color: '#e06666' },
                    { key: 'co2_sheet_buildings_households_cooking_co2_emissions', color: '#990000' },
                    { key: 'co2_sheet_buildings_households_appliances_light_co2_emissions', color: '#660000' }
                ]
            }, smallChartDefaults),
            bar_chart_industry: $.extend({
                series: [
                    { key: 'co2_sheet_industry_metal_co2_emissions', color: '#fff2cc' },
                    { key: 'co2_sheet_industry_chemical_co2_emissions', color: '#f9cb9c' },
                    { key: 'co2_sheet_industry_food_co2_emissions', color: '#ffd966' },
                    { key: 'co2_sheet_industry_paper_co2_emissions', color: '#e69138' },
                    { key: 'co2_sheet_energy_sector_total_co2_emissions', color: '#bf9000' },
                    { key: 'co2_sheet_industry_other_co2_emissions', color: '#b45f06' }
                ]
            }, smallChartDefaults),
            bar_chart_agriculture: $.extend({
                series: [
                    { key: 'co2_sheet_agriculture_heat_co2_emissions', color: '#93c47d' },
                    { key: 'co2_sheet_agriculture_power_and_light_co2_emissions', color: '#38761d' }
                ]
            }, smallChartDefaults),
            bar_chart_transport: $.extend({
                series: [
                    { key: 'co2_sheet_transport_car_co2_emissions', color: '#c9daf8' },
                    { key: 'co2_sheet_transport_busses_co2_emissions', color: '#6d9eeb' },
                    { key: 'co2_sheet_transport_trains_co2_emissions', color: '#45818e' },
                    { key: 'co2_sheet_transport_trucks_co2_emissions', color: '#1c4587' },
                    { key: 'co2_sheet_transport_ships_co2_emissions', color: '#0c343d' }
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
