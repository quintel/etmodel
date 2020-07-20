//= require d3.v2
//= require lib/models/metric
//= require lib/models/quantity
//= require jquery.quinn.min
//= require establishment_shot/main
//= require establishment_shot/error_handler
//= require establishment_shot/scenario_creator
//= require establishment_shot/scenario_updater
//= require energy_mix/stackedBarChart
//= require establishment_shot/charts/bar_chart
//= require establishment_shot/charts
//= require establishment_shot/text_updater
//= require establishment_shot/chart_renderer
//= require establishment_shot/toggle_year

$(document).ready(function () {
  new EstablishmentShot.Main($("#establishment_shot")).render();
});