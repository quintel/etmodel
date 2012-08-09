class @Accordion
  setup: =>
    @setup_callbacks()
    @open_right_tab()

  setup_callbacks: ->
    $(document).on 'click', ".accordion_element h3", (e) ->
      e.preventDefault()
      header = $(e.target).closest('h3')

      # close all slides
      ul = header.parents("ul.accordion")
      ul.find("li.accordion_element h3").removeClass('selected')
      ul.find("li.accordion_element .slide").slideUp('fast')

      # open the right one
      current = header.parents("li.accordion_element")
      current.find('h3').addClass('selected')
      current.find(".slide").slideToggle('fast')

      # update the fragment url
      key = header.data('slide')
      window.location.hash = key

      # Track event (legacy, can we remove this?)
      slide_title = $.trim(header.text())
      Tracker.track({slide: slide_title})

      # request the default chart
      chart_holder = 'chart_0'
      default_chart = header.data('default_chart')
      alternate_chart = header.data('alt_chart')
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

  # Setup slides and open the right one. The default slide can be set
  # by passing a fragment url (http://ETM/costs#slide_key)
  # Otherwise the first slide will be open by default.
  #
  open_right_tab: ->
    slide = window.location.hash.replace('#', '')
    item = if slide != ''
      $ "li.accordion_element h3[data-slide=#{slide}]"
    else
      $ 'li.accordion_element h3.selected'
    item.trigger 'click'
