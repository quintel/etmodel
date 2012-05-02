class @Scenario extends Backbone.Model
  api_session_id: =>
    key = App.settings.get('api_session_id')
    return if _.isPresent(key) then key else null

  api_attributes: =>
    s = App.settings
    data =
      area_code: s.get('area_code')
      end_year: s.get('end_year')
      scenario_id: s.get('scenario_id')
      use_fce: s.get('use_fce')

  # this method shouldn't be called as long as we keep using
  # the api_session_id fetched by the tabs_controller filter
  new_session: ->
    url = App.api_base_url() + "/api_scenarios/new.json"
    $.getJSON(url,
      {settings : this.api_attributes()},
      (data) ->
        App.settings.set({'api_session_id' : data.scenario.id})
        App.bootstrap()
    )

  user_values_url: =>
    @url_path() + "/user_values.json"

  query_url: (input_params) =>
    input_params = '' if !input_params
    this.url_path() + ".json?" + input_params

  url_path: =>
    base_url = App.api_base_url()
    base_url + "/api_scenarios/" + @api_session_id()
