class @CommonInterface
  constructor: ->
    @setup_menus()
    @setup_home_menu()
    unless navigator.userAgent.match(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i)
      @setup_tooltips()
    @setup_browser_tweaks()
    @call_the_cyclists()

  setup_home_menu: ->
    $("select[name='area_code']").change ->
      country = $(this).val()
      url = "/update_footer/?country=" + country
      $.ajax
        url: url
        method: 'get'
        success: (data) ->
          $("#logos").replaceWith(data)
          Interface.call_the_cyclists()

  set_active_movie_tab: (page) ->
    $(".movie_tabs li").removeClass 'active'
    $(".movie_tabs li##{page}").addClass 'active'

  # Checks the select tag to show custom year field select when
  # other is clicked.
  check_year_radio_buttons: ->
    elements = $('#end_year option:selected')
    if elements.val() == 'other'
      $('#other_year').show()
    else
      $('#other_year').hide()

  # footer logos rotation
  #
  call_the_cyclists: ->
    if $("#logos ul.left li").length > 1
      $("#logos ul.left").cycle
        speed: 500
        timeoutFn: (curr,next,opts,fwd) ->
          timeout = $(this).attr('timeout')
          parseInt(timeout,10)
    if $("#logos ul.right li").length > 1
      $("#logos ul.right").cycle
        speed: 500
        random: 1
        notRandomFirst: 0 #my own addition to the Cycle plugin! DS
        timeoutFn: (curr,next,opts,fwd) ->
          timeout = $(this).attr('timeout')
          parseInt(timeout,10)

  setup_menus: =>
    # Expand menus
    #
    $("a.menu_toggler").on 'click', (e) =>
      console.log e
      $t = $(e.currentTarget)
      is_open = $t.hasClass('menu-open')
      @close_all_menus()
      if !is_open
        $t.addClass('menu-open')
        $t.parent().find('.header_menu').show()
        # The arrow position must be set with JS. It used to be set via CSS,
        # but the settings menu width is variable and this turned out to be
        # the only working solution across all browsers. - PZ
        container = $t.parents('li.expandable')
        offset = container.width() - 44
        arrow = container.find('.arrow')
        arrow.css('left', offset)
      e.preventDefault()

    # Close menus when clicking outside them
    #
    $('body').mouseup (e) =>
      $t = $(e.target)
      if $t.closest(".header_menu").length == 0 &&
         !$t.is('a.menu_toggler')
        @close_all_menus()

    # Menu items
    #
    $(document).on 'click', '#disable_peak_load_tracking', ->
      if App.peak_load
        App.peak_load.disable_peak_load_tracking()

    $("select#locale").change ->
      $.ajax
        url: "/set_locale"
        method: "PUT"
        data:
          locale: $(this).val()
        success: -> window.location.reload()


  close_all_menus: ->
    $('a.menu_toggler').removeClass('menu-open')
    $('.header_menu').hide()

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
