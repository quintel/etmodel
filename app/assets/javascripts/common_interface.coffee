$ ->
  $("#read_more").click (e) ->
    e.preventDefault()
    $("#content_short").hide()
    $("#content_long").show("fast")
    $("#read_more").hide()

  $("#read_less, #con").click (e) ->
    e.preventDefault()
    $("#content_long").hide("fast")
    $("#content_short").show()
    $("#read_more").show()

  # login menu
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

  # setting menu
  $("a.settings").click (e) ->
    e.preventDefault()
    $("#settings_menu").toggle()
    $(".settings").toggleClass("menu-open")
  $(document).mouseup (e) ->
    if $(e.target).parents("a.settings").length == 0
      $(".settings").removeClass("menu-open")
      $("#settings_menu").hide()

  # setting menu
  $("a.information").click (e) ->
    e.preventDefault()
    $("#information_menu").toggle()
    $(".information").toggleClass("menu-open")
  $(document).mouseup (e) ->
    if $(e.target).parents("a.information").length == 0
      $(".information").removeClass("menu-open")
      $("#information_menu").hide()

  $("#disable_peak_load_tracking").live 'click', -> disable_peak_load_tracking()


