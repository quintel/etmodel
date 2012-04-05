/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/base_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BaseChartView = (function(_super) {

    __extends(BaseChartView, _super);

    function BaseChartView() {
      this.render_as_table = __bind(this.render_as_table, this);
      this.hide_format_toggler = __bind(this.hide_format_toggler, this);
      this.significant_digits = __bind(this.significant_digits, this);
      BaseChartView.__super__.constructor.apply(this, arguments);
    }

    BaseChartView.prototype.initialize_defaults = function() {
      return this.model.bind('change', this.render);
    };

    BaseChartView.prototype.max_value = function() {
      var max_value, sum_future, sum_present, target_results;
      sum_present = _.reduce(this.model.values_present(), this.smart_sum);
      sum_future = _.reduce(this.model.values_future(), this.smart_sum);
      target_results = _.flatten(this.model.target_results());
      return max_value = _.max($.merge([sum_present, sum_future], target_results));
    };

    BaseChartView.prototype.smart_sum = function(sum, x) {
      var y;
      y = x > 0 ? x : 0;
      return sum + y;
    };

    BaseChartView.prototype.significant_digits = function() {
      var max;
      max = this.max_value() / Math.pow(1000, this.data_scale());
      if (max >= 100) return 0;
      if (max >= 10) return 1;
      return 2;
    };

    BaseChartView.prototype.parsed_unit = function() {
      var unit;
      unit = this.model.get('unit');
      return Metric.scale_unit(this.max_value(), unit);
    };

    BaseChartView.prototype.data_scale = function() {
      return Metric.power_of_thousand(this.max_value());
    };

    BaseChartView.prototype.container_id = function() {
      return this.model.get("container");
    };

    BaseChartView.prototype.container_node = function() {
      return $("#" + (this.container_id()));
    };

    BaseChartView.prototype.clear_container = function() {
      return this.container_node().empty();
    };

    BaseChartView.prototype.title_node = function() {
      return $("#charts_holder h3");
    };

    BaseChartView.prototype.update_title = function() {
      return this.title_node().html(this.model.get("name"));
    };

    BaseChartView.prototype.create_legend = function(opts) {
      return {
        renderer: $.jqplot.EnhancedLegendRenderer,
        show: true,
        location: opts.location || 's',
        fontSize: this.defaults.font_size,
        placement: "outside",
        labels: opts.labels || this.model.labels(),
        yoffset: opts.offset || 25,
        rendererOptions: {
          numberColumns: opts.num_columns,
          seriesToggle: false
        }
      };
    };

    BaseChartView.prototype.defaults = {
      shadow: false,
      font_size: '11px',
      grid: {
        drawGridLines: false,
        gridLineColor: '#cccccc',
        background: '#ffffff',
        borderColor: '#cccccc',
        borderWidth: 0.0,
        shadow: false
      },
      stacked_line_axis_default: {
        tickOptions: {
          formatString: '%d',
          fontSize: '11px'
        }
      },
      highlighter: {
        show: false
      }
    };

    BaseChartView.prototype.toggle_format = function() {
      this.display_as_table = !this.display_as_table;
      if (this.can_be_shown_as_table() && this.display_as_table) {
        return this.render_as_table();
      } else {
        return this.render();
      }
    };

    BaseChartView.prototype.hide_format_toggler = function() {
      return $("a.toggle_chart_format").hide();
    };

    BaseChartView.prototype.can_be_shown_as_table = function() {
      return true;
    };

    BaseChartView.prototype.render_as_table = function() {
      var table, table_data, tmpl;
      this.clear_container();
      table_data = {
        start_year: App.settings.get('start_year'),
        end_year: App.settings.get('end_year'),
        series: this.model.formatted_series_hash()
      };
      tmpl = $("#chart-table-template").html();
      table = _.template(tmpl, table_data);
      return this.container_node().html(table);
    };

    return BaseChartView;

  })(Backbone.View);

}).call(this);
