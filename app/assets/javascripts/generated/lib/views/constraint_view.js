/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/constraint_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.ConstraintView = (function(_super) {

    __extends(ConstraintView, _super);

    function ConstraintView() {
      this.cleanArrows = __bind(this.cleanArrows, this);
      this.updateArrows = __bind(this.updateArrows, this);
      this.format_result = __bind(this.format_result, this);
      this.open_popup = __bind(this.open_popup, this);
      this.render_total_cost_label = __bind(this.render_total_cost_label, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      ConstraintView.__super__.constructor.apply(this, arguments);
    }

    ConstraintView.prototype.initialize = function() {
      this.id = "constraint_" + (this.model.get('id'));
      this.dom_id = "#" + this.id;
      this.element = $(this.dom_id);
      this.arrow_element = $('.arrow', this.dom_id);
      this.element.bind('mousedown', this.open_popup);
      this.model.bind('change:result', this.render);
      return this.model.view = this;
    };

    ConstraintView.prototype.render = function() {
      var formatted_value;
      if (this.model.get("key") === 'total_energy_cost') {
        this.render_total_cost_label();
      }
      formatted_value = this.format_result();
      $('strong', this.dom_id).empty().append(formatted_value);
      this.updateArrows();
      return this;
    };

    ConstraintView.prototype.render_total_cost_label = function() {
      var label, scale, unit, value;
      if (this.model.error()) return '';
      value = this.model.result() * 1000000000;
      scale = Metric.power_of_thousand(value);
      unit = I18n.t('units.currency.' + Metric.power_of_thousand_to_string(scale));
      label = "(" + unit + ")";
      return $('.header .sub_header', this.dom_id).html(label);
    };

    ConstraintView.prototype.open_popup = function() {
      var constraint, constraint_id, key, popup_height, url;
      constraint = $(this.dom_id);
      constraint_id = this.model.get('id');
      key = this.model.get('key');
      popup_height = key === 'loss_of_load' ? 435 : 400;
      url = $(constraint).attr('href') + "?t=" + timestamp();
      return $(constraint).fancybox({
        href: url,
        type: 'iframe',
        height: popup_height,
        width: 600,
        padding: 0
      });
    };

    ConstraintView.prototype.format_result = function() {
      var key, out, result;
      result = this.model.result();
      key = this.model.get('key');
      if (this.model.error()) return '';
      out = (function() {
        switch (key) {
          case 'total_energy_cost':
            return Metric.euros_to_string(result * 1000000000);
          case 'household_energy_cost':
            return I18n.toCurrency(result, {
              precision: 0,
              unit: '&euro;'
            });
          case 'total_primary_energy':
          case 'employment':
          case 'co2_reduction':
            return Metric.ratio_as_percentage(result, true);
          case 'net_energy_import':
            return Metric.ratio_as_percentage(result, false, 1);
          case 'security_of_supply':
            return Metric.round_number(result, 1);
          case 'renewable_percentage':
            return Metric.ratio_as_percentage(result);
          case 'bio_footprint':
            return "" + (Metric.round_number(result, 1)) + "x" + (App.settings.country().toUpperCase());
          case 'targets_met':
            return null;
          case 'loss_of_load':
            return Metric.ratio_as_percentage(result, false, 1);
          case 'renewable_electricity_percentage':
            return Metric.ratio_as_percentage(result);
          case 'score':
            return parseInt(result, 10);
          default:
            return result;
        }
      })();
      return out;
    };

    ConstraintView.prototype.updateArrows = function() {
      var arrow_element, diff, newClass,
        _this = this;
      diff = this.model.calculate_diff(this.model.get('result'), this.model.get('previous_result'));
      if (diff === void 0 || diff === null) return false;
      arrow_element = $('.arrow', this.dom_id);
      this.cleanArrows();
      if (diff > 0) {
        newClass = 'arrow_up';
      } else if (diff < 0) {
        newClass = 'arrow_down';
      } else {
        newClass = 'arrow_neutral';
      }
      arrow_element.addClass(newClass);
      arrow_element.css('opacity', 1.0);
      return Util.cancelableAction("updateArrows " + (this.model.get('id')), function() {
        return arrow_element.animate({
          opacity: 0.0
        }, 1000);
      }, {
        'sleepTime': 30000
      });
    };

    ConstraintView.prototype.cleanArrows = function() {
      var arrow_element;
      arrow_element = $('.arrow', this.dom_id);
      arrow_element.removeClass('arrow_neutral');
      arrow_element.removeClass('arrow_down');
      return arrow_element.removeClass('arrow_up');
    };

    return ConstraintView;

  })(Backbone.View);

}).call(this);
