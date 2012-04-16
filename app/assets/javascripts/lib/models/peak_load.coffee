class @PeakLoad extends Backbone.Model
  # move demand population to the right => peak load is triggered => Popup
  # move demand population to the left => no peak load anymore
  # move demand population to the right again => peak load is triggered again
  # => if you want the popup to reappear again, set this to true.
  #     (disadvantage: for every api_call the settings have to be synced to etmodel)

  SHOW_EVERY_TIME_PEAK_LOAD_IS_TRIGGERED : false

  initialize : ->
    @bind('change', @check_results)
    @gqueries =
      'lv' :    new Gquery({key : 'peak_load_check_lv'})
      'mv-lv' : new Gquery({key : 'peak_load_check_mv_lv'})
      'mv'    : new Gquery({key : 'peak_load_check_mv'})
      'hv-mv' : new Gquery({key : 'peak_load_check_hv_mv'})
      'hv'    : new Gquery({key : 'peak_load_check_hv'})
    @grid_investment_needed_gquery = new Gquery({key : 'peak_load_check_total'})

  check_results: =>
    if @grid_investment_needed()
      if @unknown_parts_affected() && App.settings.get("track_peak_load")
        @notify_grid_investment_needed(@parts_affected().join(','))
        if !@SHOW_EVERY_TIME_PEAK_LOAD_IS_TRIGGERED then @save_state_in_session()
    if @SHOW_EVERY_TIME_PEAK_LOAD_IS_TRIGGERED then @save_state_in_session()

  save_state_in_session: =>
    App.settings.set({'network_parts_affected' : @parts_affected() })
    App.settings.save()

  grid_investment_needed: =>
    @grid_investment_needed_gquery.result()[0][1]

  # @return Array [lv, mv-lv, mv, hv-mv, hv]
  parts_affected: =>
    _.compact(
      _.map @gqueries, (gquery, part_affected) ->
        if gquery.result()[0][1] then part_affected else null
    )

  unknown_parts_affected: =>
    _.any @parts_affected(), (key) ->
      !(_.include(App.settings.get("network_parts_affected"), key))

  notify_grid_investment_needed: (parts) ->
    $.fancybox
      width   : 960
      padding : 30
      href    : '/pages/grid_investment_needed?parts=' + parts
      type    : 'ajax'
      onComplete: -> $.fancybox.resize()

  disable_peak_load_tracking: ->
    $("#track_peak_load_settings").click() # simulate clicking the checkbox in the settings menu
    close_fancybox()
