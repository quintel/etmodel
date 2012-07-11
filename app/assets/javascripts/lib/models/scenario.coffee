class @Scenario extends Backbone.Model
  api_session_id: =>
    key = App.settings.get('api_session_id')
    return if key? then key else null

  api_attributes: =>
    s = App.settings
    data =
      area_code: s.get('area_code')
      end_year: s.get('end_year')
      scenario_id: s.get('scenario_id')
      use_fce: s.get('use_fce')
      source: 'ETM'

  user_values_url: =>
    @url_path() + "/user_values.json"

  query_url: (input_params) =>
    input_params = '' if !input_params
    this.url_path() + ".json?" + input_params

  url_path: =>
    base_url = App.api_base_url()
    base_url + "/api_scenarios/" + @api_session_id()

  reset: =>
    App.settings.set({
      scenario_id: null,
      network_parts_affected: []
      }, {silent: true})
    @new_session()
    # Take it easy. TODO: use deferred objects and refactor the js app events
    setTimeout(App.load_user_values, 1200)
