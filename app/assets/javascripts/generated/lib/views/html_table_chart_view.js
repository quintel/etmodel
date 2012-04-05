/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/html_table_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.HtmlTableChartView = (function(_super) {

    __extends(HtmlTableChartView, _super);

    function HtmlTableChartView() {
      this.merit_order_sort = __bind(this.merit_order_sort, this);
      this.build_gqueries = __bind(this.build_gqueries, this);
      this.render = __bind(this.render, this);
      HtmlTableChartView.__super__.constructor.apply(this, arguments);
    }

    HtmlTableChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    HtmlTableChartView.prototype.render = function() {
      this.clear_container();
      this.container_node().html(this.table_html());
      this.fill_cells();
      if (this.model.get("id") === 116) return this.merit_order_sort();
    };

    HtmlTableChartView.prototype.table_html = function() {
      return charts.html[this.model.get("id")];
    };

    HtmlTableChartView.prototype.build_gqueries = function() {
      var cell, gquery, html, _i, _len, _ref, _results;
      html = $(this.table_html());
      _ref = html.find("td[data-gquery]");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        gquery = $(cell).data('gquery');
        _results.push(this.model.series.add({
          gquery_key: gquery
        }));
      }
      return _results;
    };

    HtmlTableChartView.prototype.fill_cells = function() {
      var cell, gqid, raw_value, serie, value, _i, _len, _ref;
      _ref = this.dynamic_cells();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        gqid = $(cell).data('gquery');
        serie = this.model.series.with_gquery(gqid);
        if (!serie) {
          console.warn("Missing gquery: " + gqid);
          return;
        }
        raw_value = serie.future_value();
        value = Metric.round_number(raw_value, 1);
        $(cell).html(value);
      }
    };

    HtmlTableChartView.prototype.dynamic_cells = function() {
      return this.container_node().find("td[data-gquery]");
    };

    HtmlTableChartView.prototype.can_be_shown_as_table = function() {
      return false;
    };

    HtmlTableChartView.prototype.merit_order_sort = function() {
      var rows,
        _this = this;
      rows = _.sortBy($("#" + (this.container_id()) + " tbody tr"), this.merit_order_position);
      rows = _.reject(rows, function(item) {
        return _this.merit_order_position(item) === 1000;
      });
      return this.container_node().find("tbody").html(rows);
    };

    HtmlTableChartView.prototype.merit_order_position = function(item) {
      return parseInt($(item).find("td:first").text());
    };

    return HtmlTableChartView;

  })(BaseChartView);

}).call(this);
