class @Setting extends Backbone.Model
  constructor: ->
    super
    @on 'change:use_fce', @on_fce_status_change

  url: -> '/settings'

  # Always use PUT requests
  isNew : -> false

  toggle_fce: (event) =>
    @set(use_fce: !! $(event.target).attr('checked'))

  on_fce_status_change: (setting, use_fce) =>
    # Old scenarios may provide "null" instead of true/false, and this causes
    # the FCE warning to toggle on.
    use_fce = false unless use_fce is true

    # Status change may be triggered by things other than the checkbox.
    $('#settings_use_fce').attr('checked', use_fce)

    $('.fce_notice').toggle(use_fce)

    App.settings.save use_fce: use_fce
    App.call_api()

    # update dashboard item text
    if item = dashboard.find_by_key('co2_reduction')
      item.view.update_header(
        if use_fce
          I18n.t 'constraints.greenhouse_gas.label'
        else
          I18n.t 'constraints.co2_reduction.label' )

  toggle_peak_load_tracking: ->
    App.settings.save
      track_peak_load: $("#track_peak_load_settings").is(':checked')

  # Used by the bio-footprint dashboard item
  country: => @get('area_code').split('-')[0]

  # Is MO enabled?
  merit_order_enabled: ->
    values = App.input_elements.user_values.settings_enable_merit_order
    values? && values.user == 1

  toggle_merit_order: ->
    item = App.input_elements.user_values.settings_enable_merit_order
    if item?
      new_val = !item.user
      item.user = if new_val then 1 else 0
      App.call_api
        settings_enable_merit_order: item.user
      Interface.close_all_menus()
