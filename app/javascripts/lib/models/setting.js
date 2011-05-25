var Setting = Backbone.Model.extend({
  initialize : function() {
    this.bind('change:api_session_key', this.save);
  },

  url : function() {
    return '/settings'
  },

  isNew : function() {
    return false;
  }
});