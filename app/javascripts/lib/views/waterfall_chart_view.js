/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 16:07:55 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/waterfall_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.WaterfallChartView = (function(_super) {

    __extends(WaterfallChartView, _super);

    function WaterfallChartView() {
      this.render = __bind(this.render, this);
      WaterfallChartView.__super__.constructor.apply(this, arguments);
    }

    WaterfallChartView.prototype.initialize = function() {
      this.initialize_defaults();
      return this.HEIGHT = '460px';
    };

    WaterfallChartView.prototype.render = function() {
      this.clear_container();
      return InitializeWaterfall(this.model.get("container"), this.results(), this.model.get('unit'), this.colors(), this.labels());
    };

    WaterfallChartView.prototype.colors = function() {
      var colors;
      colors = this.model.colors();
      colors.push(colors[0]);
      return colors;
    };

    WaterfallChartView.prototype.labels = function() {
      var label, labels;
      labels = this.model.labels();
      label = this.model.get('id') === 51 ? App.settings.get("end_year") : 'Total';
      labels.push(label);
      return labels;
    };

    WaterfallChartView.prototype.results = function() {
      var series;
      series = this.model.series.map(function(serie) {
        var future, present;
        present = serie.result_pairs()[0];
        future = serie.result_pairs()[1];
        if (serie.get('group') === 'value') {
          return present;
        } else {
          return future - present;
        }
      });
      return series;
    };

    return WaterfallChartView;

  })(BaseChartView);

}).call(this);
