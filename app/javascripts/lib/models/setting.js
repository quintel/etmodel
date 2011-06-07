var Setting = Backbone.Model.extend({
  initialize : function() {
    this.bind('change:api_session_key', this.save);
    this.bind('change:complexity', this.save);
    this.bind('change:track_peak_load', this.save);
  },

  url : function() {
    return '/settings';
  },

  isNew : function() {
    return false;
  }
});