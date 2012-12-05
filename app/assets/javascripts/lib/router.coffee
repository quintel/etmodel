class @Router extends Backbone.Router
  routes:
    "demand/:sidebar" : "demand"
    "costs/:sidebar"  : "costs"
    "targets/:sidebar": "targets"
    "supply/:sidebar" : "supply"

  demand:  (sidebar, slide = null) => @load_slides('demand', sidebar, slide)
  costs:   (sidebar, slide = null) => @load_slides('costs', sidebar, slide)
  targets: (sidebar, slide = null) => @load_slides('targets', sidebar, slide)
  supply:  (sidebar, slide = null) => @load_slides('supply', sidebar, slide)

  load_slides: (tab, sidebar, slide = null) ->
    url = "/scenario/#{tab}/#{sidebar}/#{slide}"
    $.ajax
      url: url
      dataType: 'script'

  load_default_slides: =>
    key = Backbone.history.getFragment() || 'demand/households'
    [tab, sidebar, slide] = key.split('/')
    @load_slides tab, sidebar, slide
    $("#sidebar h4[data-key=#{tab}]").click()
    $("#sidebar li##{sidebar}").addClass 'active'


