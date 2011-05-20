var Setting = Backbone.Model.extend({
  initialize : function() {
  },

  url : function() {
    return '/settings'
  },
  isNew : function() {
    return false;
  }
});