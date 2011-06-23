// jqPlot doesn't work when chart_wrapper is inside a element that is hidden (display: none).
// Therefore, we have to move the .constraint_popup outside the view area (bottom: 8000px),
// and animate the shadowbox-outer to an opacity of 0.01, because fadeIn/fadeOut sets display: none at the end.

var ConstraintView = Backbone.View.extend({
  initialize : function() {
    _.bindAll(this, 'render', 'open_popup', 'close_all_popups');
    this.id = "constraint_"+this.model.get('id');
    this.dom_id = '#'+this.id;
    this.element = $(this.dom_id);
    this.arrow_element = $('.arrow', this.dom_id);

    this.element.bind('click', this.open_popup);
    $('.constraint_popup', this.element).live('click', this.close_all_popups);

    this.model.bind('change:result', this.render);
    this.model.view = this;
  },

  render : function() {
    $('strong', this.dom_id).empty().append(this.format_result());
    this.updateArrows();
    return this;
  },

  open_popup : function() {
    var constraint = $(this.dom_id);
    var constraint_id = this.model.get('id');
    this.close_all_popups();
    // if the user clicks a second time on an open popup
    // we hide it
    if(window.dashboard.current_popup == constraint_id) {
      window.dashboard.current_popup = null;
      return;
    } else {
      // otherwise we load the new one
      window.dashboard.current_popup = constraint_id;
    }
    $('.constraint_popup', constraint).css('bottom', '80px');
    $('#shadowbox-outer', constraint).animate({opacity: 0.95}, 'slow');
    $.get($(constraint).attr('rel')+"?t="+timestamp(), function(data) {
      $('#shadowbox-body', constraint).html(data);
    });      
  },

  close_all_popups : function() {
    // DEBT: is there any reason not to remove the element from the dom?
    // PZ - Thu 23 Jun 2011 11:31:03 CEST
    $('.constraint_popup').css('bottom', '8000px');
  },

  // Formats the result of calculate_result() for the end-user
  format_result : function() {
    var result = this.model.get('result');
    var key = this.model.get('key');
    var result_rounded = Metric.round_number(result, 2);

    if (key == 'total_primary_energy' ) 
      return this.format_percentage(result, true);
    else if (key == 'co2_reduction' )
      return this.format_percentage(result, true);
    else if (key == 'net_energy_import') 
      return this.format_percentage(result); // TODO add :signed => false
    else if (key == 'renewable_percentage') 
      return this.format_percentage(result); // TODO add :signed => false
    else if (key == 'total_energy_cost')
      return this.format_with_prefix(result_rounded, '&euro;'); // Metric.currency((result / BILLIONS))
    else if (key == 'not_shown') // bio_footprint actually
      return this.format_with_suffix(result_rounded,'x'+ App.settings.get("country").toUpperCase());
    else if (key == 'targets_met') 
      return null; //Metric.out_of(result, Current.gql.policy.goals.length)
    else if (key == 'score')
      return parseInt(result,10);
    else
      return result;
  },

  format_with_prefix : function(value, prefix) {
    return prefix + value;
  },

  format_with_suffix : function(value, suffix) {
    return "" + value + suffix;
  },

  /**
   * If the precentage is signed then a + should appear when a number is positive
   */
     format_percentage : function(value, signed) {
    value = Metric.round_number(value * 100, 1);
    if ( (signed != undefined || signed != null) && (value > 0.0)) { 
      value = "+"+value;
    };
    return this.format_with_suffix(value, '%');
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
