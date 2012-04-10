# admin section interface tweaks
#
$ ->
  $('#output_element_serie_color').live 'change', () ->
    $('.color_hint').css("background-color",$(this).attr('value'))
