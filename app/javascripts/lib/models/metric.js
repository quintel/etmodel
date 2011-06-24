var Metric = {
  parsed_unit : function(value, unit) {
    var start_scale; 

    if (unit == "MT") {
      start_scale = 2;
    } else {
      start_scale = 3;
    }

    var scale = Metric.scaled_scale(value, start_scale);

    if (unit == 'PJ') {
      if (scale >= 3 && scale < 5) scale = 3;
      return Metric.scaling_in_words(scale, 'joules');
    } else if (unit == 'MT') {
      return Metric.scaling_in_words(scale, 'ton');
    } else if (unit == 'EUR') {
      return Metric.scaling_in_words(scale, 'currency');
    } else if (unit == '%') {
      return '';
    } else {
      return Metric.scaling_in_words(scale, unit);
    }
  },

  scaled : function(value, start_scale, target_scale, max_scale) {
    var scale = start_scale || 0;
    var target = target_scale || null;
    var max_scale = max_scale || 100;
    var min_scale = 0;
    
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
      var diff = target - scale;
      for (var i = Math.abs(diff); i > 0; i -= 1) {
        if (diff < 0) {
          value = value * 1000;
          scale = scale - 1;
        } else {
          value = value / 1000;
          scale = scale + 1;
        }
      }
    }
    return [parseInt(scale), value];
  },

  scaled_scale : function(value, start_scale, target_scale, max_scale) {
    return this.scaled(value, start_scale, target_scale, max_scale)[0];
  },
  scaled_value : function(value, start_scale, target_scale, max_scale) {
    return this.scaled(value, start_scale, target_scale, max_scale)[1];
  },

  /*
   * Doesn't add trailing zeros. Let's use sprintf.js in case
   */
  round_number : function(value, precision) {
    var rounded = Math.pow(10, precision);
    return Math.round(value * (rounded)) / rounded;
  },

  calculate_performance : function(now, fut) {
    if (now != null || fut != null) {
      var performance = (fut / now) - 1;
      return performance;
    } else {
    return null;
    }
  },

  /*
   * Translates a scale to a words:
   * 1000 ^ 1 = thousands
   * 1000 ^ 2 = millions
   * etc.
   *
   * @param scale [Float] The scale that must be translated into a word
   * @param unit [String] The unit - currently {currency|joules|nounit|ton}
   * Add other units on config/locales/{en|nl}.yml
   */
  scaling_in_words : function(scale, unit) {
    var scale_symbols = {
      "0" : 'unit',
      "1" : 'thousands',
      "2" : 'millions',
      "3" : 'billions',
      "4" : 'trillions',
      "5" : 'quadrillions',
      "6" : 'quintillions'
    };
    var symbol = scale_symbols["" + scale];

    return I18n.t("units." + unit + "." + symbol);
  }
  
}
