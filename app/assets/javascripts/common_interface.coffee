$ ->
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

  # login menu
  #
  $("a.signin").click (e) ->
    e.preventDefault()
    $("fieldset#signin_menu").toggle()
    $(".signin").toggleClass("menu-open")
  $("fieldset#signin_menu").mouseup (e)-> e.preventDefault()
  # close login popup if the user clicks somewhere else
  $(document).mouseup (e) ->
    if $(e.target).parents("#signin_menu").length == 0
      $(".signin").removeClass("menu-open")
      $("fieldset#signin_menu").hide()

  # settings menu
  #
  $("a.settings").click (e) ->
    e.preventDefault()
    $("#settings_menu").toggle()
    $(".settings").toggleClass("menu-open")
  $(document).mouseup (e) ->
    if $(e.target).parents("#settings_menu").length == 0
      $(".settings").removeClass("menu-open")
      $("#settings_menu").hide()

  # information menu
  #
  $("a.information").click (e) ->
    e.preventDefault()
    $("#information_menu").toggle()
    $(".information").toggleClass("menu-open")
  # close when the user clicks outside the popup
  $(document).mouseup (e) ->
    if $(e.target).parents("#information_menu").length == 0
      $(".information").removeClass("menu-open")
      $("#information_menu").hide()

  # Menu items
  #

  $("#disable_peak_load_tracking").live 'click', -> disable_peak_load_tracking()

  # locale select box
  $("select#locale").change ->
    $.ajax
      url: "/set_locale"
      method: "PUT"
      data:
        locale: $(this).val()
      success: -> window.location.reload()

  # Is this thing still used?
  $("select[name='area_code']").change ->
    country = $(this).val()
    url = "/update_footer/?country=" + country
    $.ajax
      url: url
      method: 'get'
      success: (data) ->
        $("#logos").replaceWith(data)
        Interface.call_the_cyclists()
  Interface.call_the_cyclists()

  # Tooltips
  $("a.tooltip").qtip
    content: -> $(this).attr('title')
    position:
      my: 'bottom right'
      at: 'top center'
    style:
      classes: "ui-tooltip-tipsy"

class @AppInterface
  set_active_movie_tab: (page) ->
    $(".movie_tabs li").removeClass 'active'
    $(".movie_tabs li##{page}").addClass 'active'

  # Checks the select tag to show custom year field select when
  # other is clicked.
  check_year_radio_buttons: ->
    elements = $('#end_year option:selected')
    if elements.text() == 'other'
      $('#other_year').show()
    else
      $('#other_year').hide()

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

window.Interface = new AppInterface()
