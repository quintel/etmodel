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

  $("a.overview").fancybox
    content: '
      <div class="chart_holder">
        <div id="overview_chart" class="chart_canvas">Loading...</div>
      </div>
    '
    width: 500
    height: 340
    autoSize: false
    afterShow: ->
      if Browser.hasD3Support()
        charts.load(123, 'overview_chart', {force: true})
        true
      else
        $("#overview_chart").html I18n.t('output_elements.common.old_browser')
        false

window.close_fancybox = ->
  $.fancybox.close()
