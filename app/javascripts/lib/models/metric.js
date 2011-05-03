var Metric = {
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

  round_number : function(value, round) {
    var rounded = Math.pow(10, round);
    return Math.round(value* (rounded))/rounded;
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
   * @param scale [Float] The value that must be translated into a word
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
    return I18n.t("units."+unit+'.'+scale_symbols[""+scale]);
  }
  
}
