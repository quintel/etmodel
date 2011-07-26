FuelChainView = Backbone.View.extend({
  el: '.fce_checkbox_container',
  initialize : function() {
    this.render();
  },
  render: function(){
    var use_fce = App.settings.get('use_fce');
    $("<input id='use_fce_settings' name='use_fce[settings]' type='checkbox' >").appendTo(this.el).attr('checked', use_fce);
  },
  
  events: {
    "click #use_fce_settings": "toggle_fce"
  },
  toggle_fce: function( event ){
    var use_fce = $("#use_fce_settings").is(':checked');
    App.settings.set({'use_fce' : use_fce});  
    App.call_api();
    $('.fce_notice').toggle(use_fce);    
  }
});