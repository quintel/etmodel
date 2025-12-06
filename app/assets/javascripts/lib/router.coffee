class @Router extends Backbone.Router
  routes:
    "report" : "report"
    "myc/:id" : "load_myc"
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

  # Loads the interface for use in the multi-year charts iframe. The scenario
  # ID is included in the URL in order to workaround the need for third-party
  # cookies.
  load_myc: (id) ->
    if window.globals.settings.last_etm_page
      # If a previous page is set, load the same page using the last three URL
      # components (the tab, sidebar item, and slide).
      @navigate(
        window.globals.settings.last_etm_page.split('/').slice(-3).join('/'),
        { trigger: true}
      )
    else
      @load_slides()

  update_sidebar: (tab, sidebar) ->
    unless _.compact([tab, sidebar]).length
      [tab, sidebar] = @ui_fragments()

    if $("#sidebar h4.active").data('key') != tab
      $("#sidebar h4").removeClass 'active'
      $("#sidebar h4[data-key=#{tab}]").trigger 'click'
    $("#sidebar li").removeClass 'active'
    $("#sidebar li##{sidebar}").addClass 'active'

  ui_fragments: ->
    (Backbone.history.getFragment() || 'overview/scenario_overview').split('/')

  load_default_slides: =>
    [tab, sidebar, slide] = @ui_fragments()
    @load_slides(tab, sidebar, slide)
    $("#sidebar h4[data-key=#{tab}]").click()
