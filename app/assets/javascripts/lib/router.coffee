class @Router extends Backbone.Router
  routes:
    "report" : "report"
    ":tab/:sidebar(/:slide)" : "load_slides"
    "" : "load_default_slides"
    
  report: =>
    # pass

  load_slides: (tab, sidebar, slide) ->
    url = "/scenario/#{_.compact([tab, sidebar, slide]).join('/')}"
    $.ajax
      url: url
      dataType: 'script'
    @update_sidebar tab, sidebar

  update_sidebar: (tab, sidebar) ->
    unless _.compact([tab, sidebar]).length
      [tab, sidebar] = @ui_fragments()

    if $("#sidebar h4.active").data('key') != tab
      $("#sidebar h4").removeClass 'active'
      $("#sidebar h4[data-key=#{tab}]").trigger 'click'
    $("#sidebar li").removeClass 'active'
    $("#sidebar li##{sidebar}").addClass 'active'

  ui_fragments: ->
    (Backbone.history.getFragment() || 'overview/introduction').split('/')

  load_default_slides: =>
    [tab, sidebar, slide] = @ui_fragments()
    @load_slides(tab, sidebar, slide)
    $("#sidebar h4[data-key=#{tab}]").click()
