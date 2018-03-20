EstablishmentShot.Charts = (function () {
    'use strict';

    var count = 0,
        colors = [
            '#26b01f', // green
            '#ffcf28', // yellow
            '#009cff', // blue
            '#ff2600' // red
        ],
        smallColors = [
            [
                '#9E6C00',
                '#EBA000',
                '#9E1D00',
                '#EB2B00'
            ],
            [
                '#888888',
                '#80D4FF',
                '#3C9AC9',
                '#B09300',
                '#E6C337',
                '#ffcf28'
            ],
            [
                '#38FC2D',
                '#26b01f'
            ],
            [
                '#6E3E00',
                '#B05E00',
                '#FCB100',
                '#006FB0',
                '#00A0FC'
            ]
        ],
        smallChartDefaults = function () {
            return {
                type: EstablishmentShot.BarChart,
                width: 150,
                height: 188,
                color_gradient: smallColors[count++],
                margin: {
                    top: 10,
                    right: 0,
                    bottom: 25,
                    left: 50
                }
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
                ],
                mouseover: function (d) {
                    $(".column.last .chart")
                        .stop().animate({ 'opacity': 0.3 }, 500);

                    $(".column.last .chart[data-chart='" + d.key + "']")
                        .stop().animate({'opacity': 1.0 }, 500);
                },
                mouseout: function (d) {
                    $(".column.last .chart")
                        .stop().animate({'opacity': 1.0 }, 500);
                }
            },
            co2_sheet_buildings_households_total_co2_emissions: $.extend({
                series: [
                    { key: 'co2_sheet_buildings_households_space_heating_cooling_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_hot_water_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_cooking_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_appliances_light_co2_emissions' }
                ]
            }, smallChartDefaults()),
            co2_sheet_industry_energy_total_co2_emissions: $.extend({
                series: [
                    { key: 'co2_sheet_industry_metal_co2_emissions' },
                    { key: 'co2_sheet_industry_chemical_co2_emissions' },
                    { key: 'co2_sheet_industry_food_co2_emissions' },
                    { key: 'co2_sheet_industry_paper_co2_emissions' },
                    { key: 'co2_sheet_energy_sector_total_co2_emissions' },
                    { key: 'co2_sheet_industry_other_co2_emissions' }
                ]
            }, smallChartDefaults()),
            co2_sheet_agriculture_total_co2_emissions: $.extend({
                series: [
                    { key: 'co2_sheet_agriculture_heat_co2_emissions' },
                    { key: 'co2_sheet_agriculture_power_and_light_co2_emissions' }
                ]
            }, smallChartDefaults()),
            co2_sheet_transport_total_co2_emissions: $.extend({
                series: [
                    { key: 'co2_sheet_transport_car_co2_emissions' },
                    { key: 'co2_sheet_transport_busses_co2_emissions' },
                    { key: 'co2_sheet_transport_trains_co2_emissions' },
                    { key: 'co2_sheet_transport_trucks_co2_emissions' },
                    { key: 'co2_sheet_transport_ships_co2_emissions' }
                ]
            }, smallChartDefaults())
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
