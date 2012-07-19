class @Accordion
  setup: ->
    accordion = $('.accordion').accordion
      header: '.headline',
      collapsible: true,
      fillSpace: false,
      autoHeight: false,
      active: false

    # Setup slides and open the right one. The default slide can be set
    # by passing a fragment url (http://ETM/costs#slide_key)
    # Otherwise the first slide will be open by default.
    #
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

    # Here we load the new default chart
    $('.ui-accordion').bind 'accordionchange', (ev, ui) ->
      slide_key = ui.newHeader.data('slide')
      window.location.hash = slide_key

      slide_title = $.trim(ui.newHeader.text())
      Tracker.track({slide: slide_title})
      if ui.newHeader.length > 0
        output_element_id = ui.newHeader.data('default_chart')
        alt_output_element_id = ui.newHeader.data('alt_chart')

        chart_settings = App.settings.get('charts')
        chart_settings.main_chart.default = output_element_id
        App.settings.set 'charts', chart_settings

        $("a.default_charts").hide() if charts.current_id() == output_element_id
        unless chart_settings.main_chart.chart_id
          window.charts.load(output_element_id, 'main_chart', {alternate: alt_output_element_id})

    $(".slide").each (i, slide) ->
      $("a.btn-done", slide).filter(".next, .previous").click () ->
        accordion.accordion("activate",i + ($(this).is(".next") ? 1 : -1))
        return false

  reset: =>
    $(".accordion").accordion("destroy")
    @setup()


$(document).ready ->
  acc = new Accordion()
  acc.setup()
