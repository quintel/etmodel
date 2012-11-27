class @BlockChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    unless @already_on_screen()
      @clear_container()
      @container_node().html(@html())
      @setup_checkboxes()
      @setup_callbacks()
      @hide_format_toggler()
    @update_block_charts()

  already_on_screen: =>
    @container_node().find("#blockchart").length == 1

  html: => @model.get 'html'

  results: =>
    @model.series.map (serie) -> serie.result()

  can_be_shown_as_table: -> false

  # for some reason the standard backbone views events don't work
  # as expected
  setup_callbacks: =>
    $('#block_list li').mouseenter -> $(this).find("ul").show(1)
    $('#block_list li').mouseleave -> $(this).find("ul").hide(1)
    $('.show_hide_block').click (e) =>
      block_id = $(e.target).attr('data-block_id')
      @toggle_block(block_id)
      @align_checkbox(block_id)
      false
    $('.block_list_checkbox').click (e) =>
      if $(e.target).is(':checked')
        for item in $(e.target).parent().find('.show_hide_block')
          block_id = $(item).attr('data-block_id')
          @show_block(block_id)
      else
        for item in $(e.target).parent().find('.show_hide_block')
          block_id = $(item).attr('data-block_id')
          @hide_block(block_id)
    $(".block").qtip
      content:
        title: ->
          $(this).attr('data-title')
        text: ->
          item = $(this)
          cost =   Metric.autoscale_value item.parent().data('cost'), 'Eur/MWhe'
          invest = Metric.autoscale_value item.parent().data('invest'), 'Eur/MWe'
          url = "/descriptions/#{item.attr('data-description_id')}"
          "#{item.attr('data-description')}
          <br/><br/>
          #{I18n.t 'output_elements.block_chart.costs'}: #{cost}<br/>
          #{I18n.t 'output_elements.block_chart.investment_costs'}: #{invest}
          <br/><br>
          <a href='#{url}' class='fancybox'>#{I18n.t 'output_elements.common.read_more'}</a>"
      hide:
        fixed: true
        delay: 300
      position:
        my: 'bottom center'
        at: 'top center'
      style:
        tip:
          corner: false

  setup_checkboxes: ->
    for item in $(".block_list_checkbox")
      if $(item).parent().find('.visible').length > 0
        $(item).attr('checked', true)

  toggle_block: (block_id) ->
    if $('#canvas').find('#block_container_'+block_id).hasClass('visible')
      @hide_block(block_id)
    else
      @show_block(block_id)

  align_checkbox: (block_id) ->
    checkbox = $('#show_hide_block_'+block_id).parent().parent().parent().find('.block_list_checkbox')
    list_blocks = $('#block_list #show_hide_block_'+block_id).parent().parent()
    if list_blocks.find('.visible').length > 0
      checkbox.attr('checked', true)
    else
      $(this).parent().find(':checkbox').attr('checked', false)
      checkbox.attr('checked', false)

  # when the user selects a checkbox
  show_block: (block_id) =>
    $('#canvas').find('#block_container_'+block_id).removeClass('invisible').addClass('visible').css({'z-index':@current_z_index})
    $('#block_list #show_hide_block_'+block_id).addClass('visible').removeClass('invisible')
    $.ajax
       url: "/output_elements/visible/block_"+block_id
       method: 'post'
    @update_block_charts()

  # when the user deselects a checkbox
  hide_block: (block_id) =>
    $('#canvas').find('#block_container_'+block_id).removeClass('visible').addClass('invisible')
    $('#block_list #show_hide_block_'+block_id).addClass('invisible').removeClass('visible')
    $.ajax
      url: "/output_elements/invisible/block_"+block_id
      method: 'post'
    @update_block_charts()

  update_block_charts: =>
    data_array = @results()
    max_cost = 0
    max_invest = 0

    canvas = @container_node().find('#canvas')
    canvas_width  = canvas.width()
    canvas_height = canvas.height()

    for block in data_array
      if ($('#block_container_'+block[0]).hasClass('visible'))
        max_cost = block[1] if max_cost < block[1]
        max_invest = block[2] if max_invest < block[2]

    # Allow for some extra room at the top and right of the chart, otherwise
    # the labels for the most extreme values appear outside.
    max_cost   = if max_cost < 200 then 200 else max_cost * 1.15
    max_invest = if max_invest < 5 then 5 else max_invest * 1.15

    # update x axis
    ticks = $('#x-axis li')
    ticks.each (index,tick) ->
      value = (max_invest / 5) * (index + 1)
      $('#'+tick.id).text(Math.round(value))
    # update x axis
    ticks = $('#y-axis li')
    ticks.each (index,tick) ->
      value = (max_cost / 5) * (5 - index)
      $('#'+tick.id).text(Math.round(value))
    # update blocks
    for block in data_array
      cost = block[1]
      invest = block[2]
      block_bottom = ((cost / max_cost)   * canvas_height) || 0
      block_left   = ((invest / max_invest) * canvas_width)  || 0

      $item = $("#block_container_#{ block[0] }")
      # IE doesn't like animating from "auto" to a percentage.
      # remove a few pixels: the balloon tip has an offset
      $item.animate
        bottom: "#{ block_bottom - 6}px"
        left:   "#{ block_left - 6}px"
      $item.attr('data-cost', cost)
      $item.attr('data-invest', invest)
