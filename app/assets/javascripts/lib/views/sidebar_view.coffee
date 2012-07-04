class @SidebarView extends Backbone.View
  bootstrap: ->
    for item in $("#sidebar ul li")
      gquery = $(item).attr('data-gquery')
      gqueries.find_or_create_by_key(gquery) if gquery

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

window.sidebar = new SidebarView()
