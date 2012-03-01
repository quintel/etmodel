/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 11:41:54 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/models/metric.coffee
 */

(function() {

  this.Metric = {
    parsed_unit: function(value, unit) {
      var scale, start_scale;
      if (unit === "MT") {
        start_scale = 2;
      } else if (unit === "euro") {
        unit === "EUR";
        start_scale = 0;
      } else {
        start_scale = 3;
      }
      scale = Metric.scaled_scale(value, start_scale);
      if (unit === 'PJ') {
        if (scale >= 3 && scale < 5) scale = 3;
        return Metric.scaling_in_words(scale, 'joules');
      } else if (unit === 'MT') {
        return Metric.scaling_in_words(scale, 'ton');
      } else if (unit === 'EUR') {
        return Metric.scaling_in_words(scale, 'currency');
      } else if (unit === 'MW') {
        return Metric.scaling_in_words(scale, 'watt');
      } else if (unit === '%') {
        return '%';
      } else {
        return Metric.scaling_in_words(scale, unit);
      }
    },
    scaled: function(value, start_scale, target_scale, max_scale) {
      var diff, i, min_scale, scale, target;
      scale = start_scale || 0;
      target = target_scale || null;
      min_scale = 0;
      max_scale = max_scale || 100;
      if (!target) {
        while (value >= 0 && scale < max_scale) {
          value = value / 1000;
          scale = scale + 1;
        }
        while (value < 1 && scale > min_scale) {
          value = value * 1000;
          scale = scale - 1;
        }
      } else {
        diff = target - scale;
        i = Math.abs(diff);
        while (i > 0) {
          if (diff < 0) {
            value = value * 1000;
            scale = scale - 1;
          } else {
            value = value / 1000;
            scale = scale + 1;
          }
          i--;
        }
      }
      return [parseInt(scale), value];
    },
    scaled_scale: function(value, start_scale, target_scale, max_scale) {
      return this.scaled(value, start_scale, target_scale, max_scale)[0];
    },
    scaled_value: function(value, start_scale, target_scale, max_scale) {
      return this.scaled(value, start_scale, target_scale, max_scale)[1];
    },
    scaling_in_words: function(scale, unit) {
      var scale_symbols, symbol;
      scale_symbols = {
        "0": 'unit',
        "1": 'thousands',
        "2": 'millions',
        "3": 'billions',
        "4": 'trillions',
        "5": 'quadrillions',
        "6": 'quintillions'
      };
      symbol = scale_symbols["" + scale];
      return I18n.t("units." + unit + "." + symbol);
    },
    round_number: function(value, precision) {
      var rounded;
      rounded = Math.pow(10, precision);
      return Math.round(value * rounded) / rounded;
    },
    calculate_performance: function(now, fut) {
      if (now === null || fut === null || fut === 0) return null;
      return fut / now - 1;
    },
    autoscale_value: function(x, unit, precision) {
      var out, output, pow, prefix, scale_string, suffix, value;
      precision = precision || 0;
      pow = Metric.power_of_thousand(x);
      value = x / Math.pow(1000, pow);
      value = Metric.round_number(value, precision);
      scale_string = Metric.power_of_thousand_to_string(pow);
      prefix = '';
      out = '';
      suffix = '';
      switch (unit) {
        case '%':
          out = Metric.percentage_to_string(x);
          break;
        case 'MJ':
          out = x / Math.pow(1000, pow);
          suffix = I18n.t('units.joules.' + scale_string);
          break;
        case 'MW':
          out = x / Math.pow(1000, pow);
          suffix = I18n.t('units.watt.' + scale_string);
          break;
        case 'euro':
          out = value;
          prefix = "&euro;";
          break;
        default:
          out = x;
      }
      output = prefix + out + suffix;
      return output;
    },
    percentage_to_string: function(x, prefix, precision) {
      var value;
      precision = precision || 1;
      prefix = prefix || false;
      value = Metric.round_number(x, precision);
      if (prefix && value > 0.0) value = "+" + value;
      return '' + value + '%';
    },
    ratio_as_percentage: function(x, prefix, precision) {
      return Metric.percentage_to_string(x * 100, prefix, precision);
    },
    euros_to_string: function(x, unit_suffix) {
      var abs_value, prefix, rounded, scale, suffix, value;
      prefix = x < 0 ? "-" : "";
      abs_value = Math.abs(x);
      scale = Metric.power_of_thousand(x);
      value = abs_value / Math.pow(1000, scale);
      suffix = '';
      if (unit_suffix) {
        suffix = I18n.t('units.currency.' + Metric.power_of_thousand_to_string(scale));
      }
      rounded = Metric.round_number(value, 1).toString();
      if (abs_value < 1000 && _.indexOf(rounded, '.') !== -1) {
        rounded = rounded.split('.');
        if (rounded[1] && rounded[1].length === 1) rounded[1] += '0';
        rounded = rounded.join('.');
      }
      return "" + prefix + "&euro;" + rounded + suffix;
    },
    power_of_thousand: function(x) {
      return parseInt(Math.log(Math.abs(x)) / Math.log(1000));
    },
    power_of_thousand_to_string: function(x) {
      switch (x) {
        case 0:
          return 'unit';
        case 1:
          return 'thousands';
        case 2:
          return 'millions';
        case 3:
          return 'billions';
        case 4:
          return 'trillions';
        case 5:
          return 'quadrillions';
        case 6:
          return 'quintillions';
        default:
          return null;
      }
    }
  };

}).call(this);
