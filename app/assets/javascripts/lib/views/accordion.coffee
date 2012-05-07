class @Accordion
  setup: ->
    accordion = $('.accordion').accordion({
      header: '.headline',
      collapsible: true,
      fillSpace: false,
      autoHeight: false,
      active: false
    })

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
      if (ui.newHeader.length > 0)
        output_element_id = parseInt(ui.newHeader.attr('id').match(/\d+$/))

        return if output_element_id == 32

        window.charts.current_default_chart = output_element_id
        # if the user has selected a chart then we keep showing it
        if !!window.charts.user_selected_chart
          # if the user selected chart is the default chart for the slide then
          # let's go back to the standard behaviour, ie show the default chart
          # whenever we click on a new slide
          if window.charts.user_selected_chart == output_element_id
            window.charts.user_selected_chart = null
            $("a.default_charts").hide()
          return
        else
          # otherwise the chart has to be shown
          window.charts.load(output_element_id)
          $("a.default_charts").hide()

    $(".slide").each (i, slide) ->
      $("a.btn-done", slide).filter(".next, .previous").click () ->
        accordion.accordion("activate",i + ($(this).is(".next") ? 1 : -1))
        return false


$(document).ready ->
  acc = new Accordion()
  acc.setup()




