/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 16:21:31 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/html_table_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.HtmlTableChartView = (function(_super) {

    __extends(HtmlTableChartView, _super);

    function HtmlTableChartView() {
      this.render = __bind(this.render, this);
      HtmlTableChartView.__super__.constructor.apply(this, arguments);
    }

    HtmlTableChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    HtmlTableChartView.prototype.render = function() {
      this.clear_container();
      this.model.container_node().html(window.table_content);
      return this.fill_cells();
    };

    HtmlTableChartView.prototype.fill_cells = function() {
      console.log("Filling cells");
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
      return this.model.container_node().find("td");
    };

    return HtmlTableChartView;

  })(BaseChartView);

}).call(this);
