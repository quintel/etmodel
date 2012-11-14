$ ->
  $.fancybox.defaults.helpers.overlay.opacity = 0.4

  $(".valuees a.label, a.fancybox").fancybox
    type: 'ajax'
    href: $(this).attr('href')
    autoSize: true
    maxWidth: 960

  $("a.fancybox_image").fancybox
    type: 'image'

  $("a.select_chart").fancybox
    href: $(this).attr('href')
    type: 'ajax'
    width    : 960
    height   : 600
    padding: 0

  $("a.prediction").fancybox
    href: $(this).attr('href')
    width    : 960
    height   : 650
    padding  : 0
    type     : 'iframe'

  $('#overlay_container a').live 'click', (i,el) ->
    if !$(this).hasClass('no_target')
      window.open($(this).attr('href'), '_blank')
    return null

window.close_fancybox = ->
  $.fancybox.close()
