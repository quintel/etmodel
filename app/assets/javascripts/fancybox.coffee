$ ->
  $(".valuees a.label, a.fancybox").live 'click', ->
    $(this).fancybox
      padding  : 20
      titleShow: false
      ajax:
        type: "GET"
      onComplete: ->
        setTimeout((-> $.fancybox.resize()) , 100)
       $("#fancybox-inner").css({'overflow-x':'hidden'})
    $(this).trigger('click')
    return false

  $("a.tutorial_button").live 'click', ->
    $(this).fancybox
      width    : 940
      titleShow: false
      padding  : 0
      opacity: false
      scrolling: 'no'
      ajax:
        type: "GET"
      onComplete: ->
       $("#fancybox-outer").css({'background':'transparent'})
       $(".fancy-bg").css({'display':'none'})
      onClosed: ->
       $("#fancybox-outer").css({'background':'white'})
       $(".fancy-bg").css({'display':'true'})
    $(this).trigger('click')
    return false

  $("a.select_chart").live 'click', ->
    $(this).fancybox
      width    : 960
      height   : 600
      titleShow: false
      padding  : 0
      ajax:
        type: "GET"
      onComplete: ->
        $("#fancybox-inner").css({'overflow-x':'hidden'})
    $(this).trigger('click')
    return false

  $("a.prediction").live 'click', ->
    $(this).fancybox
      width    : 960
      height   : 650
      titleShow: false
      padding  : 0
      type     : 'iframe'
      ajax:
        type: "GET"
    $(this).trigger('click')
    return false

  $('#overlay_container a').live 'click', (i,el) ->
    if !$(this).hasClass('no_target')
      window.open($(this).attr('href'), '_blank')
    return null

window.close_fancybox = ->
  $.fancybox.close()
