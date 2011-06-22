/*
 *
 */
var Scenario = Backbone.Model.extend({

  initialize : function() {
    _.bindAll(this, 'update_api');
  },

  api_session_key : function() {
    var key = App.settings.get('api_session_key');
    return _.isPresent(key) ? key : null;
  },

  update_api : function() {
    $.getJSON(this.query_url(), {'settings' : this.api_attributes()}, 
      function(data) {
        App.call_api();
      }
    );
  },

  api_attributes : function() {
    var s = App.settings;
    var data = {
      'country' : s.get('country'),
      'region' : s.get('region'),
      'end_year' : s.get('end_year'),
      "scenario_id" : s.get('scenario_id')
    };
    return data;
  },

  // this method shouldn't be called as long as we keep using
  // the api_session_key fetched by the tabs_controller filter
  new_session : function() {
    console.log('js fetching new_session', this.api_attributes());
    var url = globals.api_url + "/api_scenarios/new.json?callback=?&";
    $.getJSON(url, {settings : this.api_attributes()},
      function(data) {
        App.settings.set({'api_session_key' : data.api_scenario.api_session_key});
        App.bootstrap();
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
    return globals.api_url + "/api_scenarios/"+this.api_session_key();
  }
});
