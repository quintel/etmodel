class @Accordion
  setup: =>
    @bootstrapped = false
    @setup_callbacks()
    @open_right_tab()
    @bootstrapped = true

  setup_callbacks: ->
    $(document).on 'click', ".accordion_element h3", (e) =>
      e.preventDefault()
      header = $(e.target).closest('h3')
      current = header.parents("li.accordion_element")

      if header.hasClass('selected') && current.find(".slide").is(':visible')
        return


      # close all slides
      ul = header.parents("ul.accordion")
      ul.find("li.accordion_element h3").removeClass('selected')
      ul.find("li.accordion_element .slide").slideUp(300, 'linear')
      App.input_elements.close_all_info_boxes() if App.input_elements

      # open the right one
      current.find('h3').addClass('selected')
      current.find(".slide").slideToggle(300, 'linear')

      # update the fragment url
      url = header.find('a').attr('href')
      App.router.navigate(url)

    # update page title
      titleComponents = [
        $("h3.selected").text().trim(),
        $('#title h2').text().trim(),
        I18n.t('meta.name')
      ]

      window.document.title =
        titleComponents.filter((comp) => comp.length).join(' - ')

      # Track event (legacy, can we remove this?)
      slide_title = $.trim(header.text())
      Tracker.track({slide: slide_title})

      # request the default chart
      available_holders =
        App.charts.models
          .filter((chart) -> !chart.get('locked'))
          .map((chart) -> chart.get('container'))

      default_chart = header.data('default_chart')
      alternate_chart = header.data('alt_chart')
      # store the default chart for this slide
      App.charts.default_chart_id = default_chart

      # load chart. On application's bootstrap the chart is loaded using the
      # settings hash (to restore properly the locked charts); after that the
      # charts are loaded according to the accordion events
      if @bootstrapped
        if App.settings.charts_enabled()
          App.charts.load_into_available_holder(
            default_chart, alternate: alternate_chart
          )

          App.charts.forEach((chart) -> chart.view.update_header())
        else
          App.call_api()

      App.analytics.sendPageView(window.location.pathname, document.title)

  open_right_tab: ->
    $("h3.selected").trigger 'click'
