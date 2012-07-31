class @Accordion
  setup: ->
    @accordion = $('.accordion').accordion
      header: '.headline',
      collapsible: true,
      fillSpace: false,
      autoHeight: false,
      active: false
    @open_right_tab()
    @setup_callbacks()

    # Setup slides and open the right one. The default slide can be set
    # by passing a fragment url (http://ETM/costs#slide_key)
    # Otherwise the first slide will be open by default.
    #
  open_right_tab: ->
    slide_keys = []
    i = 0
    for e in $('li.accordion_element')
      open_slide_index = i if ($(e).is('.selected'))
      $(e).show()
      i += 1
      # Store the slide keys in an array. We need this to get the index
      # of the slide we'd like to open
      slide_key = $(".headline", e).data('slide')
      slide_keys.push "##{slide_key}"

    # open default/requested slide
    if slide = window.location.hash
      slide_index = slide_keys.indexOf(slide)
      # deal with bad names
      slide_index = open_slide_index if slide_index == -1
    else
      slide_index = open_slide_index
    $('.ui-accordion').accordion("activate", slide_index)

  setup_callbacks: =>
    # Here we load the new default chart
    $('.ui-accordion').bind 'accordionchange', (e, ui) ->
      element = ui.newHeader

      # update url fragment
      slide_key = element.data('slide')
      window.location.hash = slide_key

      # track event
      slide_title = $.trim(element.text())
      Tracker.track({slide: slide_title})

      # load default chart as needed
      chart_holder = 'chart_0'
      if element.length > 0
        default_chart = element.data('default_chart')
        alternate_chart = element.data('alt_chart')
        # store the default chart for this slide
        chart_settings = App.settings.get('charts')
        chart_settings[chart_holder].default = default_chart
        App.settings.set 'charts', chart_settings

        # show/hide the default chart button
        showing_default = charts.current_chart_in(chart_holder) == default_chart
        $("a.default_chart").toggle(!showing_default)

        # load chart
        unless charts.pinned_chart_in(chart_holder)
          charts.load(default_chart, chart_holder, {alternate: alternate_chart})

    # next button
    i = 1
    for slide in $('.slide')
      $('a.next_slide', slide).click (e) =>
        e.preventDefault()
        @accordion.accordion "activate", i
        i += 1

  reset: =>
    $(".accordion").accordion("destroy")
    @setup()


$(document).ready ->
  acc = new Accordion()
  acc.setup()
