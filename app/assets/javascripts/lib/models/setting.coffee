class @Setting extends Backbone.Model
  initialize: ->
    @bind('change:api_session_id', @save)
    @bind('change:track_peak_load', @save)
    @bind('change:use_fce', @save)
    @bind('change:current_round', @save)
    @bind('change:use_merit_order', @save)

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

  toggle_merit_order: ->
    enabled = $("#use_merit_order_settings").is(':checked')
    App.settings.set({'use_merit_order' : enabled})
    # UGLY
    App.call_api("input[900]=" + (enabled ? 1.0 : 0.0))

  # Used by the bio-footprint dashboard item
  country: => @get('area_code').split('-')[0]

$ ->
  # TODO: move somewhere else
  # store the current round (watt-nu)
  $("#round-selector input").change ->
    App.settings.set({current_round: $(this).val()})
    targets.update_total_score()
