class @CommonInterface
  constructor: ->
    unless navigator.userAgent.match(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i)
      @setup_tooltips()
    @setup_browser_tweaks()

  set_active_movie_tab: (page) ->
    $(".movie_tabs li").removeClass 'active'
    $(".movie_tabs li##{page}").addClass 'active'

  # Tooltips. Works with AJAX-injected content, too
  #
  setup_tooltips: ->
    $(document).on 'mouseover', 'a.tooltip', (e) ->
      $(this).qtip {
        overwrite: false
        content: -> $(this).attr('title')
        show:
          event: e.type
          ready: true
        hide:
          event: 'click mouseleave'
        position:
          my: 'bottom right'
          at: 'top center'
        style:
          classes: "qtip-tipsy"
        }, e

  setup_browser_tweaks: ->
    # TODO: check if this is still needed, was added for an old bug - PZ
    if _.include(['iPad', 'iPhone', 'iPod'], navigator.platform)
      $("#footer").css("position", "static")

    if $.browser.msie
      # A 1px increase fixes some bad aliasing when resizing the image down
      # to non-HiDPI resolutions.
      $('#header_inside img[src$="@2x.png"]').attr(width: '401')

    # Adds "Search" to the search field for browsers which do not support the
    # "placeholder" attribute.
    unless Modernizr.input.placeholder
      search      = $("#header_inside input[name=q]")
      placeholder = search.attr('placeholder')

      if search.val()?.length is 0
        search.val(placeholder)

      search.focus ->
        # Remove the search field value only if it matches the placeholder;
        # we do not want to erase the users search text.
        search.val('') if search.val() is placeholder

      search.blur ->
        value = search.val() or ''

        # Similarly, only add the placeholder back if the user did not enter
        # a value.
        if value.length is 0 or value is placeholder or not value.match(/\S/)
          search.val(placeholder)

$ ->
  window.Interface = new CommonInterface()
