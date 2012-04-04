class @BlockChartView extends BaseChartView
  initialize: ->
    @current_z_index = 5
    @initialize_defaults()
    @setup_callbacks()

  render: =>
    $("a.select_chart").hide()
    $("a.toggle_chart_format").hide()
    @setup_checkboxes()
    @update_block_charts()

  results: =>
    @model.series.map (serie) -> serie.result()

  can_be_shown_as_table: -> false

  setup_callbacks: =>
    @bind_hovers()
    $('#block_list li').hover(
      -> $(this).find("ul").show(1),
      -> $(this).find("ul").hide(1)
    )
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

  bind_hovers: ->
    $('.block_container').hover(
      (e) ->
        $(e.target).addClass("hover").css({"z-index": @current_z_index}).find(".content").stop().animate({width: '150px', height: '100px'})
        $(e.target).find(".header").stop().animate({width: '150px'})
        $(".block_container").stop().not(".hover")
        $("#tooltip").stop()
        @current_z_index++
      , ->
        $(this).removeClass("hover").find('.content').stop().animate({width:'75px', height: '0px'})
        $(this).find('.header').stop().animate({width:'75px'})
        $(".block_container").stop()
        $("#tooltip").stop()
      )


  show_block: (block_id) =>
    $('#canvas').find('#block_container_'+block_id).removeClass('invisible').addClass('visible').css({'z-index':@current_z_index})
    $('#block_list #show_hide_block_'+block_id).addClass('visible').removeClass('invisible')
    $.ajax
       url: "/output_elements/visible/block_"+block_id
       method: 'post'
    @current_z_index++
    @update_block_charts()

  hide_block: (block_id) =>
    $('#canvas').find('#block_container_'+block_id).removeClass('visible').addClass('invisible')
    $('#block_list #show_hide_block_'+block_id).addClass('invisible').removeClass('visible')
    $.ajax
      url: "/output_elements/invisible/block_"+block_id
      method: 'post'
    @update_block_charts()
  
  update_block_charts: =>
    data_array = @results()
    # max values check
    max_cost = 0
    max_invest = 0
    $.each data_array, (index, block) ->
      if ($('#block_container_'+block[0]).hasClass('visible'))
        max_cost = block[1] if max_cost < block[1]
        max_invest = block[2] if max_invest < block[2]
    # minimal value check
    max_cost = 200 if max_cost < 200
    max_invest = 5 if max_invest < 5
    # update x axis
    ticks = $('#x-axis li')
    value = null
    ticks.each (index,tick) ->
      value = (max_invest / 5) * (index + 1)
      $('#'+tick.id).text(Math.round(value))
    # update x axis
    ticks = $('#y-axis li')
    ticks.each (index,tick) ->
      value = (max_cost / 5) * (5 - index)
      $('#'+tick.id).text(Math.round(value))
    # update blocks
    $.each data_array, (index, block) ->
      block_bottom = block[1] * 100 / max_cost
      block_left = block[2] * 100 / max_invest
      $('#block_container_'+block[0]).animate({'bottom': block_bottom + "%",'left': block_left + "%"})
