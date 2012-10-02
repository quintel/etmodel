class @SidebarView extends Backbone.View
  bootstrap: ->
    # setup accordion
    $('#sidebar h4').on 'click', ->
      $(this).next('ul').slideToggle('fast')

    # Create gqueries for the inline bars
    for item in $("#sidebar ul li")
      gquery = $(item).attr('data-gquery')
      gqueries.find_or_create_by_key(gquery) if gquery

    # AJAX-based navigation
    if Browser.hasProperPushStateSupport()
      # hijack sidebar links
      $(document).on 'click', "a[data-nav=true]", (e) ->
        e.preventDefault()
        $("ul.accordion, #title").busyBox
          spinner: "<em>Loading</em>"
        $("#sidebar li").removeClass("active")
        $(e.target).parents("li").addClass("active")
        url = $(e.target).attr('href') ||
              $(e.target).parents('a').attr('href')
        $.ajax
          url: url
          dataType: 'script'
        history.pushState({url: url}, url, url)


  update_bars: ->
    for item in $("#sidebar ul li")
      key = $(item).attr('data-gquery')
      continue unless key
      gquery = gqueries.with_key(key)
      return unless gquery
      result = gquery.future_value()

      $item      = $(item)
      percentage = Math.round(result * 100)
      pixels     = "#{ percentage }px"

      $item.find('.bar').animate(width: pixels, 1000)
      $item.find('.value').html("#{ percentage }%").animate(left: pixels, 1000)
