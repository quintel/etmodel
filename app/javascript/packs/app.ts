/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// Polyfills
// ---------

import 'core-js/features/array/fill';
import 'core-js/features/array/flat';

// Core
// -----

import { AccessToken, GuestToken } from '../models/AccessToken';
window.AccessToken = AccessToken;
window.GuestToken = GuestToken;

// Charts
// ------

import Bezier from '../charts/Bezier';
import ElectricityNetworkLoad from '../charts/ElectricityNetworkLoad';
import HourlySummarized from '../charts/HourlySummarized';
import Line from '../charts/Line';
import HourlyStackedArea from '../charts/HourlyStackedArea';
import StackedBar from '../charts/StackedBar';

import backwardsCompat from '../charts/utils/backwardsCompat';

window.D3 ||= {};

window.D3.bezier = { View: backwardsCompat(Bezier) };
window.D3.electricity_network_load = { View: backwardsCompat(ElectricityNetworkLoad) };
window.D3.hourly_stacked_area = { View: backwardsCompat(HourlyStackedArea) };
window.D3.hourly_summarized = { View: backwardsCompat(HourlySummarized) };
window.D3.line = { View: backwardsCompat(Line) };
window.D3.stacked_bar = { View: backwardsCompat(StackedBar) };

window.D3.electricity_hv_network_load = window.D3.electricity_network_load;
window.D3.electricity_lv_network_load = window.D3.electricity_network_load;
window.D3.electricity_mv_network_load = window.D3.electricity_network_load;
window.D3.hourly_balance = window.D3.merit_order_hourly_flexibility;
window.D3.merit_order_hourly_flexibility = window.hourly_area;
window.D3.network_load = window.D3.electricity_network_load;

// Curve sampling
// --------------

import sampleCurves, { sliceValues } from '../charts/HourlyBase/sampleCurves';

// Backwards compatibility for older hourly charts.
window.MeritTransformator = {
  sliceValues,
  transform: sampleCurves,
};

import DateSelect from '../charts/HourlyBase/DateSelect';
window.D3ChartDateSelect = DateSelect;

// Other Backbone classes
// ----------------------

import ChartListView from '../views/ChartListView';
import CustomCurveChooserView from '../views/CustomCurveChooserView';
import MultiCurveChooserView from '../views/MultiCurveChooserView';

window.ChartListView = ChartListView;
window.CustomCurveChooserView = CustomCurveChooserView;
window.MultiCurveChooserView = MultiCurveChooserView;

// Extensions to legacy classes
// ----------------------------

import { onClick as saveAsPNGClick } from '../charts/utils/saveAsPNG';

window.BaseChartView.saveAsPNG = saveAsPNGClick;

// Sentry Browser Profiling
// ------------------------

import '../sentry';
