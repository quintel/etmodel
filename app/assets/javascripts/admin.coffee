# admin section interface tweaks
#
$ ->
  $('#output_element_serie_color').on 'change', ->
    $('.color_hint').css("background-color", $(this).val())

  $('#output_element_serie_color').change();

window.Admin =
  colorTemplateResult: (state) =>
    if (!state.id)
      return state.text

    color = $('<span class="color_preview" />').css({
      backgroundColor: state.element && state.element.value || state.text
    })

    $('<span />').append(color, ' ', state.text)
