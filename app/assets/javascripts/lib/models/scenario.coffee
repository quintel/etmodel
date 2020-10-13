class @Scenario extends Backbone.Model
  apiSessionID: ->
    key = App.settings.get('api_session_id')
    return if key? then key else null

  api_session_id: ->
    @apiSessionID()

  apiAttributes: ->
    s = App.settings
    data =
      area_code: s.get('area_code')
      end_year: s.get('end_year')
      preset_scenario_id: s.get('preset_scenario_id')
      use_fce: s.get('use_fce')
      source: 'ETM'

  api_attributes: ->
    @apiAttributes()

  # Returns the base scenario URL, taking into account CORS support
  urlPath: -> App.api.path "scenarios/#{@api_session_id()}"

  url_path: -> @urlPath()

  etenginePath: ->
    App.scenario_url()

  reset: => App.reset_scenario()
