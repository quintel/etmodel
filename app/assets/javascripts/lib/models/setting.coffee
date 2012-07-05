class @Setting extends Backbone.Model
  initialize: ->
    @bind('change:api_session_id', @save)
    @bind('change:track_peak_load', @save)
    @bind('change:use_fce', @save)
    @bind('change:main_chart', @save)
    @bind('change:secondary_chart', @save)

  url: -> '/settings'

  # RD: This is still needed, otherwise when loading a new page the stored settings are not there anymore
  isNew : -> false

  toggle_fce: ->
    # there are 2 checkboxes!
    use_fce = !!$(this).attr('checked')
    # update the other one
    $(".inline_use_fce, #settings_use_fce").attr('checked', use_fce)
    App.settings.set({'use_fce' : use_fce})
    $('.fce_notice').toggle(use_fce)
    App.call_api()

  toggle_peak_load_tracking: ->
    App.settings.set({'track_peak_load' : $("#track_peak_load_settings").is(':checked')})

  # Used by the bio-footprint dashboard item
  country: => @get('area_code').split('-')[0]
