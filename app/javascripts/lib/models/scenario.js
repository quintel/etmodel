/*
 *
 */
var Scenario = Backbone.Model.extend({

  initialize : function() {
    _.bindAll(this, 'update_api', 'copy_shared_settings');
    this.bind('change', this.update_api);

    if (this.api_session_id() == null) {
      this.new_session();
    }
  },

  copy_shared_settings : function() {
    var s = App.settings;
    this.set({
      end_year : s.get('end_year'), 
      country : s.get('country'),
      region : s.get('region')
    });
  },

  api_session_id : function() {
    return $.cookie('api_session_id');
  },

  update_api : function() {
    console.log('updating api');
    $.getJSON(this.query_url(), {'settings' : this.api_attributes()}, 
      function(data) {
        App.call_api();
      }
    );
  },

  api_attributes : function() {
    var data = {
      'country' : this.get('country'),
      'end_year' : this.get('end_year')
    };
    return data;
  },

  new_session : function() {
    var url = globals.api_url + "/api_scenarios/new.json?callback=?&";
    $.getJSON(url,
      function(data) {
        $.cookie('api_session_id', data.api_scenario.api_session_key, { path : '/' });
      }
    );
  },

  user_values_url : function() {
    return this.url_path()+"/user_values.json?callback=?&";
  },

  query_url : function(input_params) {
    if (!input_params) input_params = '';
    var url = this.url_path()+".json?callback=?&"+input_params;
    return url;
  },
  
  url_path : function() {
    return globals.api_url + "/api_scenarios/"+this.api_session_id();
  }
});
