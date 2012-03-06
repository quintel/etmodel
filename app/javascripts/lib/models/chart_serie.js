/* DO NOT MODIFY. This file was compiled Tue, 06 Mar 2012 10:55:50 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/models/chart_serie.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.ChartSerie = (function(_super) {

    __extends(ChartSerie, _super);

    function ChartSerie() {
      ChartSerie.__super__.constructor.apply(this, arguments);
    }

    ChartSerie.prototype.initialize = function() {
      var gquery;
      gquery = new Gquery({
        key: this.get('gquery_key')
      });
      return this.set({
        gquery: gquery
      });
    };

    ChartSerie.prototype.result = function() {
      return this.get('gquery').result();
    };

    ChartSerie.prototype.result_pairs = function() {
      return [this.present_value(), this.future_value()];
    };

    ChartSerie.prototype.future_value = function() {
      return this.result()[1][1];
    };

    ChartSerie.prototype.present_value = function() {
      return this.result()[0][1];
    };

    return ChartSerie;

  })(Backbone.Model);

  this.ChartSeries = (function(_super) {

    __extends(ChartSeries, _super);

    function ChartSeries() {
      ChartSeries.__super__.constructor.apply(this, arguments);
    }

    ChartSeries.prototype.model = ChartSerie;

    return ChartSeries;

  })(Backbone.Collection);

}).call(this);
