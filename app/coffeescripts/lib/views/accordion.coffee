$(document).ready ->
  accordion = $('.accordion').accordion({
    header: '.headline',
    collapsible: true,
    fillSpace: false,
    autoHeight: false,
    active: false
  })

  i = 0
  for e in $('li.accordion_element', this)
    open_slide_index = i if ($(e).is('.selected'))
    $(e).show()
    i += 1
  # open default/requested slide
  $('.ui-accordion').accordion("activate", open_slide_index)

  # Here we load the new default chart
  $('.ui-accordion').bind 'accordionchange', (ev,ui) ->
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

