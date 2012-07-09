class @ConstraintView extends Backbone.View
  initialize: () =>
    @id = "constraint_#{@model.get('id')}"
    @dom_id = "##{@id}"
    @element = $(@dom_id)
    @arrow_element = $('.arrow', @dom_id)
    @element.bind('mousedown', @open_popup)
    @model.bind('change:result', @render)
    @model.view = this

  render: () =>
    if(@model.get("key") == 'total_energy_cost')
      @render_total_cost_label()
    formatted_value = @format_result()
    $('strong', @dom_id).empty().append(formatted_value)
    @updateArrows()
    this

  # different behaviour unfortunately
  render_total_cost_label: () =>
    return '' if @model.error()
    value = @model.result() * 1000000000
    scale = Metric.power_of_thousand(value)
    unit  = I18n.t('units.currency.' + Metric.power_of_thousand_to_string(scale))
    label = "(#{unit})"
    $('.header .sub_header', @dom_id).html(label)

  open_popup: () =>
    constraint = $(@dom_id)
    constraint_id = @model.get('id')
    key = @model.get('key')
    url = $(constraint).attr('href')
    $(constraint).fancybox
      href: url
      type: 'iframe'
      width: 600
      height: 550
      padding: 0


  # Formats the result of calculate_result() for the end-user
  format_result: () =>
    result = @model.result()
    key    = @model.get('key')
    return '' if @model.error()

    out = switch key
      when 'total_energy_cost'
        Metric.euros_to_string(result * 1000000000)
      when 'household_energy_cost'
        I18n.toCurrency(result, { precision: 0, unit: '&euro;' })
      when 'total_primary_energy', 'employment', 'co2_reduction'
        # show + prefix if needed
        Metric.ratio_as_percentage(result, true)
      when 'net_energy_import'
        # 1 point precision
        Metric.ratio_as_percentage(result, false, 1)
      when 'security_of_supply'
        Metric.round_number(result, 1)
      when 'renewable_percentage'
        Metric.ratio_as_percentage(result)
      when 'bio_footprint'
        "#{Metric.round_number(result, 1)}x#{App.settings.country().toUpperCase()}"
      when 'targets_met'
        null
      when 'loss_of_load'
        Metric.ratio_as_percentage(result, false, 1)
      when 'renewable_electricity_percentage'
        Metric.ratio_as_percentage(result)
      when 'score'
        parseInt(result,10)
      else
        result
    out
  # Updates the arrows, if the difference is negative .
  # @param diff - the difference of old_value and new_value.
  updateArrows: () =>
    diff = @model.calculate_diff @model.get('result'), @model.get('previous_result')
    return false if (diff == undefined || diff == null)
    arrow_element = $('.arrow', @dom_id)
    @cleanArrows()
    if diff > 0
      newClass = 'arrow_up'
    else if diff < 0
      newClass = 'arrow_down'
    else
      newClass = 'arrow_neutral'

    arrow_element.addClass(newClass)
    arrow_element.css('opacity', 1.0)

    # make sure the arrows take their original form after 30 seconds
    Util.cancelableAction("updateArrows #{@model.get('id')}",
      => arrow_element.animate({opacity: 0.0}, 1000),
      {'sleepTime': 30000}
    )

  cleanArrows:() =>
    arrow_element = $('.arrow', @dom_id)
    arrow_element.removeClass('arrow_neutral')
    arrow_element.removeClass('arrow_down')
    arrow_element.removeClass('arrow_up')
