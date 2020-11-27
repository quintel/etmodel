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

// Charts
// ------

import Bezier from '../charts/Bezier';
import HourlySummarized from '../charts/HourlySummarized';
import MeritOrderHourlyFlexibility from '../charts/MeritOrderHourlyFlexibility';
import StackedBar from '../charts/StackedBar';

import backwardsCompat from '../charts/utils/backwardsCompat';

window.D3 ||= {};
window.D3.bezier = { View: backwardsCompat(Bezier) };
window.D3.hourly_summarized = { View: backwardsCompat(HourlySummarized) };
window.D3.merit_order_hourly_flexibility = { View: backwardsCompat(MeritOrderHourlyFlexibility) };
window.D3.stacked_bar = { View: backwardsCompat(StackedBar) };

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
