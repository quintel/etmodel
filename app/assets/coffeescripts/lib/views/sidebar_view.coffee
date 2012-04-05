class @SidebarView extends Backbone.View
  bootstrap: ->
    for item in $("#sidebar ul li")
      gquery = $(item).attr('data-gquery')
      new Gquery({key: gquery}) if gquery

  update_bars: ->
    for item in $("#sidebar ul li")
      key = $(item).attr('data-gquery')
      continue unless key
      gquery = gqueries.with_key(key)[0]
      return unless gquery
      result = gquery.get('future_value')
      percentage = "#{Math.round(result * 100)}%"
      padded_percentage = "#{Math.round(result * 90)}%"
      $(item).find(".bar").animate({width: padded_percentage})
      $(item).find(".value").html(percentage).animate({left: padded_percentage})

window.sidebar = new SidebarView()
