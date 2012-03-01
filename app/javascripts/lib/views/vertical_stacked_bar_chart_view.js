/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 13:48:01 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/vertical_stacked_bar_chart_view.coffee
 */

(function() {

  this.VerticalStackedBarChartView = BaseChartView.extend({
    initialize: function() {
      return this.initialize_defaults();
    },
    render: function() {
      this.clear_container();
      return InitializeVerticalStackedBar(this.model.get("container"), this.results(), this.ticks(), this.filler(), this.model.get('show_point_label'), this.parsed_unit(), this.model.colors(), this.model.labels());
    },
    results: function() {
      var result, results, scale, serie, x, _i, _len, _ref;
      results = this.results_without_targets();
      scale = this.data_scale();
      if (!this.model.get('percentage')) {
        results = _.map(results, function(x) {
          return _.map(x, function(value) {
            return Metric.scale_value(value, scale);
          });
        });
      }
      _ref = this.model.target_series();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        serie = _ref[_i];
        result = serie.result()[0][1];
        result = Metric.scale_value(result, scale);
        x = parseFloat(serie.get('target_line_position'));
        results.push([[x - 0.4, result], [x + 0.4, result]]);
      }
      return results;
    },
    results_without_targets: function() {
      return _.map(this.model.non_target_series(), function(serie) {
        return serie.result_pairs();
      });
    },
    filler: function() {
      return _.map(this.model.non_target_series(), function(serie) {
        return {};
      });
    },
    ticks: function() {
      return [App.settings.get("start_year"), App.settings.get("end_year")];
    }
  });

}).call(this);
