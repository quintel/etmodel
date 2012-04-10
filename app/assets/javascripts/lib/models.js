/*
 * convention for model files:
 * a file models/foo.js should contain:
 * - var Foo = Backbone.Model.extend({})
 * - var FooList = Backbone.Collection.extend({})
 * - optionally: window.foos = new FooList()
 * 
 * This imitates the Rails way, where Model and Collection
 * is in the same class/file. And reduces file-count.
 *
 */


//= require lib/models/constraint
//= require lib/models/chart
//= require lib/models/chart_serie
//= require lib/models/block_chart_serie
//= require lib/models/scatter_chart_serie
//= require lib/models/input_element
//= require lib/models/input_element_balancer
//= require lib/models/metric
//= require lib/models/gquery
//= require lib/models/peak_load
//= require lib/models/scenario
//= require lib/models/policy_goal
//= require lib/models/setting
//= require lib/models/tracker
