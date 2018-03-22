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
                '#DDDDDE',
                '#9E6C00',
                '#EBA000',
                '#9E1D00',
                '#EB2B00'
            ],
            [
                '#DDDDDE',
                '#CCE4FF',
                '#80D4FF',
                '#3C9AC9',
                '#B01200',
                '#E6C337',
                '#ffcf28'
            ],
            [
                '#DDDDDE',
                '#38DC2D',
                '#26b01f'
            ],
            [
                '#DDDDDE',
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
                height: 198,
                color_gradient: smallColors[count++],
                showY: true,
                showMaxLabel: false,
                margin: {
                    top: 10,
                    right: 0,
                    bottom: 20,
                    left: 50
                },
                mouseover: function (d) {
                    $(this).find(".legend ul li")
                        .stop().animate({ 'opacity': 0.2 }, 500);

                    $(this).find(".legend ul li." + d.key)
                        .stop().animate({'opacity': 1.0 }, 500);
                },
                mouseout: function (d) {
                    $(this).find(".legend ul li")
                        .stop().animate({'opacity': 1.0 }, 500);
                }
            }
        };

    return {
        charts: {
            bar_chart: {
                width: 250,
                height: 380,
                margin: {
                    top: 10,
                    right: 0,
                    bottom: 25,
                    left: 10
                },
                showY: false,
                showMaxLabel: true,
                color_gradient: colors,
                type: EstablishmentShot.BarChart,
                series: [
                    { key: 'co2_sheet_agriculture_total_co2_emissions',
                      fa_icon: '\uf06c' },
                    { key: 'co2_sheet_industry_energy_total_co2_emissions',
                      fa_icon: '\uf275' },
                    { key: 'co2_sheet_transport_total_co2_emissions',
                      fa_icon: '\uf1b9' },
                    { key: 'co2_sheet_buildings_households_total_co2_emissions',
                      fa_icon: '\uf015' }
                ],
                mouseover: function (d) {
                    $(".column .column-inner .chart")
                        .stop().animate({ 'opacity': 0.2 }, 500);

                    $(".column .column-inner .chart[data-chart='" + d.key + "']")
                        .stop().animate({'opacity': 1.0 }, 500);
                },
                mouseout: function (d) {
                    $(".column .column-inner .chart")
                        .stop().animate({'opacity': 1.0 }, 500);
                }
            },
            co2_sheet_buildings_households_total_co2_emissions: $.extend({
                left: true,
                top: false,
                fa_icon: 'f015',
                series: [
                    { key: 'co2_sheet_non_energy_emissions_built_environment' },
                    { key: 'co2_sheet_buildings_households_space_heating_cooling_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_hot_water_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_cooking_co2_emissions' },
                    { key: 'co2_sheet_buildings_households_appliances_light_co2_emissions' }
                ]
            }, smallChartDefaults()),
            co2_sheet_industry_energy_total_co2_emissions: $.extend({
                left: false,
                top: false,
                fa_icon: 'f275',
                series: [
                    { key: 'co2_sheet_non_energy_emissions_industry_energy' },
                    { key: 'co2_sheet_industry_metal_co2_emissions' },
                    { key: 'co2_sheet_industry_chemical_co2_emissions' },
                    { key: 'co2_sheet_industry_food_co2_emissions' },
                    { key: 'co2_sheet_industry_paper_co2_emissions' },
                    { key: 'co2_sheet_energy_sector_total_co2_emissions' },
                    { key: 'co2_sheet_industry_other_co2_emissions' }
                ]
            }, smallChartDefaults()),
            co2_sheet_agriculture_total_co2_emissions: $.extend({
                left: false,
                top: true,
                fa_icon: 'f06c',
                series: [
                    { key: 'co2_sheet_non_energy_emissions_agriculture' },
                    { key: 'co2_sheet_agriculture_heat_co2_emissions' },
                    { key: 'co2_sheet_agriculture_power_and_light_co2_emissions' }
                ]
            }, smallChartDefaults()),
            co2_sheet_transport_total_co2_emissions: $.extend({
                left: true,
                top: true,
                fa_icon: 'f1b9',
                series: [
                    { key: 'co2_sheet_non_energy_emissions_transport' },
                    { key: 'co2_sheet_transport_total_domestic_aviation_co2_emissions' },
                    { key: 'co2_sheet_transport_total_domestic_freight_co2_emissions' },
                    { key: 'co2_sheet_transport_total_private_transport_co2_emissions' },
                    { key: 'co2_sheet_transport_total_public_transport_co2_emissions' }
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
