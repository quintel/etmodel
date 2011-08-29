var Setting = Backbone.Model.extend({
  initialize : function() {
    this.bind('change:api_session_key', this.save);
    this.bind('change:complexity', this.save);
    this.bind('change:track_peak_load', this.save);
    this.bind('change:use_fce', this.save);
  },

  url : function() {
    return '/settings';
  },

  isNew : function() {
    return false;
  },
  
  toggle_fce: function(param){
    if (param == undefined){
      // if no parameter is send it should toggle
      var use_fce = !(App.settings.get('use_fce'));
    }
    else{
      var use_fce = param;
    }

    if (use_fce != App.settings.get('use_fce')){
      // only apply changes when the setting needs to change
      App.settings.set({'use_fce' : use_fce});  
      $("#use_fce_settings").attr('checked', use_fce);
      App.call_api();
      $('.fce_notice').toggle(use_fce);
    }
  },
  
  toggle_peak_load_tracking: function(){
    App.settings.set({track_peak_load : $("#track_peak_load_settings").is(':checked')});
  }
});