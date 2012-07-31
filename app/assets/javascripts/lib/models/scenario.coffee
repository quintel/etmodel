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
    @url_path() + "/inputs.json"

  url_path: =>
    base_url = App.api_base_url()
    base_url + "/scenarios/" + @api_session_id()

  reset: =>
    App.reset_scenario()
