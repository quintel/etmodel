var Setting = Backbone.Model.extend({
  initialize : function() {
    this.bind('change:api_session_id', this.save);
    this.bind('change:track_peak_load', this.save);
    this.bind('change:use_fce', this.save);
    this.bind('change:current_round', this.save);
    this.bind('change:use_merit_order', this.save);
  },

  url : function() {
    return '/settings';
  },

  isNew : function() {
    // RD: This is still needed, otherwise when loading a new page the stored settings are not there anymore
    return false;
  },

  toggle_fce: function(){
    // there are 2 checkboxes!
    var use_fce = !!$(this).attr('checked');
    // update the other one
    $(".inline_use_fce, #settings_use_fce").attr('checked', use_fce);
    App.settings.set({'use_fce' : use_fce});
    $('.fce_notice').toggle(use_fce);
    App.call_api();
  },

  toggle_peak_load_tracking: function(){
    App.settings.set({'track_peak_load' : $("#track_peak_load_settings").is(':checked')});
  },

  toggle_merit_order: function(){
    var enabled = $("#use_merit_order_settings").is(':checked');
    App.settings.set({'use_merit_order' : enabled});
    // UGLY
    App.call_api("input[900]=" + (enabled ? 1.0 : 0.0));
  },

  country: function(){
    return this.get('area_code').split('-')[0];
  }

});

$(document).ready(function(){
  // TODO: move somewhere else
  // store the current round (watt-nu)
  $("#round-selector input").change(function(){
    App.settings.set({current_round: $(this).val()});
    policy_goals.update_total_score();
  });
});
