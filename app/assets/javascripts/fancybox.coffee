$ ->
  $.fancybox.defaults.helpers.overlay.opacity = 0.4

  $(".valuees a.label, a.fancybox").fancybox
    type: 'ajax'
    href: $(this).attr('href')
    autoSize: true
    maxWidth: 960

  $("a.fancybox_image").fancybox
    type: 'image'

  $('document').on 'click', '#overlay_container a', (i,el) ->
    if !$(this).hasClass('no_target')
      window.open($(this).attr('href'), '_blank')
    return null

window.close_fancybox = ->
  $.fancybox.close()
