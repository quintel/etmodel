/*
 *
 */
var Scenario = Backbone.Model.extend({

  initialize : function() {
  },

  api_session_id : function() {
    var key = App.settings.get('api_session_id');
    return _.isPresent(key) ? key : null;
  },
  api_attributes : function() {
    var s = App.settings;
    var data = {
      'country' : s.get('country'),
      'region' : s.get('region'),
      'end_year' : s.get('end_year'),
      "scenario_id" : s.get('scenario_id'),
      'use_fce' : s.get('use_fce')
    };
    return data;
  },

  // this method shouldn't be called as long as we keep using
  // the api_session_id fetched by the tabs_controller filter
  new_session : function() {
    console.log('js fetching new_session', this.api_attributes());
    var url = globals.api_url + "/api_scenarios/new.json";
    $.getJSON(url, {settings : this.api_attributes()},
      function(data) {
        App.settings.set({'api_session_id' : data.api_scenario.api_session_id});
        App.bootstrap();
      }
    );
  },

  user_values_url : function() {
    return this.url_path()+"/user_values.json";
  },

  query_url : function(input_params) {
    if (!input_params) input_params = '';
    var url = this.url_path()+".json?"+input_params;
    return url;
  },
  
  url_path : function() {
    return globals.api_url + "/api_scenarios/"+this.api_session_id();
  }
});
