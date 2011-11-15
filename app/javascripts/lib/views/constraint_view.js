// jqPlot doesn't work when chart_wrapper is inside a element that is hidden (display: none).
// Therefore, we have to move the .constraint_popup outside the view area (bottom: 8000px),
// and animate the shadowbox-outer to an opacity of 0.01, because fadeIn/fadeOut sets display: none at the end.

var ConstraintView = Backbone.View.extend({
  initialize : function() {
    _.bindAll(this, 'render', 'open_popup', 'render_total_cost_label');
    this.id = "constraint_"+this.model.get('id');
    this.dom_id = '#'+this.id;
    this.element = $(this.dom_id);
    this.arrow_element = $('.arrow', this.dom_id);

    this.element.bind('mousedown', this.open_popup);

    this.model.bind('change:result', this.render);
    this.model.view = this;
  },

  render : function() {
    if(this.model.get("key") == 'total_energy_cost') {
      this.render_total_cost_label();
    }
    var formatted_value = this.format_result();
    $('strong', this.dom_id).empty().append(formatted_value);
    this.updateArrows();
    return this;
  },
  
  // different behaviour unfortunately
  render_total_cost_label : function() {
    var value = this.model.get('result') * 1000000000;
    var scale = Metric.power_of_thousand(value);
    var unit  = I18n.t('units.currency.' + Metric.power_of_thousand_to_string(scale));
    var label = "(" + unit + ")";
    $('.header .sub_header', this.dom_id).html(label);
  },

  open_popup : function() {
    var constraint = $(this.dom_id);
    var constraint_id = this.model.get('id');
    var url = $(constraint).attr('href')+"?t="+timestamp();
    $(constraint).fancybox({
      'href' : url,
      'type' : 'iframe',
      height: 400,
      width: 600,
      padding: 0
    });
  },


  // Formats the result of calculate_result() for the end-user
  format_result : function() {
    var result = this.model.get('result');
    var key    = this.model.get('key');

    switch(key) {
      case 'total_energy_cost' :
        return Metric.euros_to_string(result * 1000000000);
      case 'household_energy_cost':
        return I18n.toCurrency(result, { precision: 0, unit: '&euro;' });
      case 'total_primary_energy':
        // show + prefix if needed
        return Metric.ratio_as_percentage(result, true);
      case 'co2_reduction':
        return Metric.ratio_as_percentage(result, true);
      case 'net_energy_import':
        // 1 point precision
        return Metric.ratio_as_percentage(result, false, 1);
      case 'security_of_supply':
        return Metric.round_number(result, 1);
      case 'renewable_percentage':
        return Metric.ratio_as_percentage(result);
      case 'not_shown':
        // bio_footprint actually
        return '' + Metric.round_number(result, 1) +'x'+ App.settings.get("country").toUpperCase();
      case 'targets_met':
        return null;
      case 'score':
        return parseInt(result,10);
      default:
        return result;
    }
  },
  
  /**
   * Updates the arrows, if the difference is negative .
   * @param diff - the difference of old_value and new_value.
   */
  updateArrows : function() {
    diff = this.model.calculate_diff(this.model.get('result'),this.model.get('previous_result'));
    if (diff == undefined || diff == null) { return false; }
    var arrow_element = $('.arrow', this.dom_id);
    this.cleanArrows();
    var newClass;
    if (diff > 0) { newClass = 'arrow_up';} 
    else if(diff < 0) { newClass = 'arrow_down'; }
    else { newClass = 'arrow_neutral'; }
    
    arrow_element.addClass(newClass);
    arrow_element.css('opacity', 1.0);

    // make sure the arrows take their original form after 30 seconds
    Util.cancelableAction("updateArrows" + this.model.get('id'), $.proxy(function() {
      arrow_element.animate({opacity: 0.0}, 1000);
    }, this), {'sleepTime': 30000});
  },

  /**
   * Clean the arrwos
   */
  cleanArrows:function() {
    var arrow_element = $('.arrow', this.dom_id);
    arrow_element.removeClass('arrow_neutral');
    arrow_element.removeClass('arrow_down');
    arrow_element.removeClass('arrow_up');
  }
  

});
