class @SidebarView extends Backbone.View
  bootstrap: ->
    # setup accordion
    $('#sidebar h4').on 'click', ->
      $("#sidebar h4").removeClass("active")
      $(this).addClass('active')
      target = $(this).next('ul')
      target.slideToggle('fast')
      $("#sidebar ul").not(target).slideUp('fast')

    # Create gqueries for the inline bars
    for item in $("#sidebar ul li")
      gquery = $(item).attr('data-gquery')
      gqueries.find_or_create_by_key(gquery) if gquery

    # AJAX-based navigation
    # hijack sidebar links
    $(document).on 'click', "a[data-nav=true]", (e) ->
      e.preventDefault()
      target = $(e.target)
      $("#title").busyBox
        spinner: "<em>Loading</em>"
      $("ul.accordion").fadeOut(100)
      $("#sidebar li, #sidebar h4").removeClass("active")
      target.parents("li").addClass("active")
      target.parents('ul').prev("h4").addClass("active")
      key = target.attr('data-key') || target.parents('a').attr('data-key')
      App.router.navigate(key, { trigger: true })

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
