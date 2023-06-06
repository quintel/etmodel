# Check router.coffee to see the app callbacks.
# TODO: refactor the DOM elements class handling, the router should not
# contain this logic. The callbacks should be enclosed in a single method.
# This would prevent this ugliness you can find in router.coffee:
#
#    $("#sidebar h4[data-key=#{tab}]").click()
#
# MAYBE: the sidebar events could be handled by the standard backbone events
# hash
class @SidebarView extends Backbone.View
  bootstrap: ->
    self = this

    # setup accordion
    $('#sidebar h4').on 'click', ->
      tab = $(this)

      $("#sidebar h4").removeClass("active")
      tab.addClass('active')

      target = tab.next('ul')
      target.slideDown(300, 'linear')

      $("#sidebar ul").not(target).slideUp(300, 'linear')

      if tab.data('key') == 'data' && self.results_tip
        self.results_tip.close()

    # Create gqueries for the inline bars
    for item in $("#sidebar ul li")
      gquery = $(item).attr('data-gquery')
      gqueries.find_or_create_by_key(gquery) if gquery

    # AJAX-based navigation
    # hijack sidebar links
    $(document).on 'click', "a[data-nav=true]", (e) =>
      e.preventDefault()
      target = $(e.target)
      # Don't do anything if it's already active
      return if target.parents("li").hasClass("active")
      $("#title").busyBox
        spinner: "<em>Loading</em>"
      $("ul.accordion").fadeOut(100)
      $("#sidebar li, #sidebar h4").removeClass("active")
      target.parents("li").addClass("active")
      target.parents('ul').prev("h4").addClass("active")
      key = target.attr('data-key') || target.parents('a').attr('data-key')
      @show_sub_items()

      App.router.navigate(key, { trigger: true })

    @show_sub_items()

  show_sub_items: ->
    e = $("#sidebar ul li.active")

    if e.hasClass('child')
      parent = e.data('parent')
    else
      parent = e.attr('id')

    $("#sidebar ul li.child")
      .hide()
      .filter("[data-parent='" + parent + "']")
      .show()

  update_bars: ->
    for item in $("#sidebar ul li")
      key = $(item).attr('data-gquery')
      continue unless key
      gquery = gqueries.with_key(key)
      return unless gquery
      result = gquery.future_value()

      $item      = $(item)
      percentage = Math.round(result)
      pixels     = "#{ percentage }px"

      if percentage is 0
        vPixels = "#{ percentage + 22 }px"
      else
        vPixels = "#{ percentage + 26 }px"

      $item.find('.bar').animate(width: pixels, 300)
      $item.find('.value').html("#{ percentage }%").animate(left: vPixels, 300)
