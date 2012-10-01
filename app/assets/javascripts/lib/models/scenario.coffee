class @Scenario extends Backbone.Model
  api_session_id: =>
    key = App.settings.get('api_session_id')
    return if key? then key else null

  api_attributes: =>
    s = App.settings
    data =
      area_code: s.get('area_code')
      end_year: s.get('end_year')
      preset_scenario_id: s.get('preset_scenario_id')
      use_fce: s.get('use_fce')
      source: 'ETM'

  # Returns the base scenario URL, taking into account CORS support
  url_path: => App.api.path "/scenarios/#{@api_session_id()}"

  reset: => App.reset_scenario()
