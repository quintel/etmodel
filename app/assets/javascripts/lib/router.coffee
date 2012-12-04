class @Router extends Backbone.Router
  routes:
    "demand/:sidebar" : "demand"
    "costs/:sidebar"  : "costs"
    "targets/:sidebar": "targets"
    "supply/:sidebar" : "supply"
    "pippo": "pippo"

  demand:  (sidebar, slide = null) => @_sidebar('demand', sidebar, slide)
  costs:   (sidebar, slide = null) => @_sidebar('costs', sidebar, slide)
  targets: (sidebar, slide = null) => @_sidebar('targets', sidebar, slide)
  supply:  (sidebar, slide = null) => @_sidebar('supply', sidebar, slide)

  _sidebar: (tab, sidebar, slide = null) ->
    console.log "Opening #{tab}/#{sidebar}/#{slide}"
    url = "/scenario/#{tab}/#{sidebar}"
    $.ajax
      url: url
      dataType: 'script'


  pippo: => console.log 'pippo'

