class @Router extends Backbone.Router
  routes:
    "demand/:sidebar(/:slide)" : "demand"
    "costs/:sidebar(/:slide)"  : "costs"
    "targets/:sidebar(/:slide)": "targets"
    "supply/:sidebar(/:slide)" : "supply"
    "flexibility/:sidebar(/:slide)" : "flexibility"
    "report" : "report"

  demand:  (sidebar, slide) => @load_slides('demand', sidebar, slide)
  costs:   (sidebar, slide) => @load_slides('costs', sidebar, slide)
  targets: (sidebar, slide) => @load_slides('targets', sidebar, slide)
  supply:  (sidebar, slide) => @load_slides('supply', sidebar, slide)
  flexibility:  (sidebar, slide) => @load_slides('flexibility', sidebar, slide)

  report: =>
    # pass

  load_slides: (tab, sidebar, slide) ->
    url = "/scenario/#{tab}/#{sidebar}/#{slide}"
    $.ajax
      url: url
      dataType: 'script'
    @update_sidebar tab, sidebar

  update_sidebar: (tab, sidebar) ->
    if $("#sidebar h4.active").data('key') != tab
      $("#sidebar h4").removeClass 'active'
      $("#sidebar h4[data-key=#{tab}]").trigger 'click'
    $("#sidebar li").removeClass 'active'
    $("#sidebar li##{sidebar}").addClass 'active'

  load_default_slides: =>
    key = Backbone.history.getFragment() || 'demand/households'
    [tab, sidebar, slide] = key.split('/')
    @load_slides tab, sidebar, slide
    $("#sidebar h4[data-key=#{tab}]").click()
