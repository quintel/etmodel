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

  toggle_fce: function(param){
    var use_fce;
    if (param == undefined){
      // if no parameter is send it should toggle
      use_fce = !(App.settings.get('use_fce'));
    } else {
      use_fce = param;
    }

    if (use_fce != App.settings.get('use_fce')){
      // only apply changes when the setting needs to change
      App.settings.set({'use_fce' : use_fce});
      $("input[name*=use_fce\\[settings\\]]").attr('checked', use_fce);
      App.call_api();
      $('.fce_notice').toggle(use_fce);
    }
  },

  toggle_peak_load_tracking: function(){
    App.settings.set({'track_peak_load' : $("#track_peak_load_settings").is(':checked')});
  },

  toggle_merit_order: function(){
    var enabled = $("#use_merit_order_settings").is(':checked');
    App.settings.set({'use_merit_order' : enabled});
    // UGLY
    App.call_api("input[900]=" + (enabled ? 1.0 : 0.0));
  }
});

$(document).ready(function(){
  $("input[name*=use_fce\\[settings\\]]").attr('checked', App.settings.get('use_fce'));
  // store the current round (watt-nu)
  $("#round-selector input").change(function(){
    App.settings.set({current_round: $(this).val()});
    policy_goals.update_total_score();
  });
});
