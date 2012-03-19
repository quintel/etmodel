/* DO NOT MODIFY. This file was compiled Mon, 19 Mar 2012 10:13:47 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/html_table_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.HtmlTableChartView = (function(_super) {

    __extends(HtmlTableChartView, _super);

    function HtmlTableChartView() {
      this.merit_order_sort = __bind(this.merit_order_sort, this);
      this.render = __bind(this.render, this);
      HtmlTableChartView.__super__.constructor.apply(this, arguments);
    }

    HtmlTableChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    HtmlTableChartView.prototype.render = function() {
      this.clear_container();
      this.container_node().html(window.table_content);
      this.fill_cells();
      if (this.model.get("id") === 116) return this.merit_order_sort();
    };

    HtmlTableChartView.prototype.fill_cells = function() {
      return this.dynamic_cells().each(function() {
        var gqid, gquery, raw_value, value;
        gqid = $(this).data('gquery_id');
        gquery = window.gqueries.with_key(gqid)[0];
        if (!gquery) return;
        raw_value = gquery.result()[1][1];
        value = Metric.round_number(raw_value, 1);
        return $(this).html(value);
      });
    };

    HtmlTableChartView.prototype.dynamic_cells = function() {
      return this.container_node().find("td");
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
