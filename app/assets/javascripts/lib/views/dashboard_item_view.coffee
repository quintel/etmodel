class @DashboardItemView extends Backbone.View
  initialize: () =>
    @id = "dashboard_item_#{@model.get('key')}"
    @dom_id = "##{@id}"
    @element = $(@dom_id)
    @arrow_element = $('.arrow', @dom_id)
    @element.bind('mousedown', @open_popup)
    @model.bind('change:result', @render)
    @model.view = this

  render: () =>
    key = @model.get 'key'
    if key == 'total_energy_cost' || key == 'costs_fte'
      @render_costs_label()

    formatted_value = @format_result()
    if formatted_value == 'unavailable'
      @render_unavailable()
    else
      @element.removeClass('unavailable')
      $('strong', @dom_id).empty().append(formatted_value)
      @updateArrows()
    this

  # different behaviour unfortunately
  render_costs_label: () =>
    return '' if @model.error()
    value = @model.result()
    value *= 1000000000 if @model.get('key') == 'total_energy_cost'
    return if _.isNaN(value)

    scale = Metric.power_of_thousand_to_string(Metric.power_of_thousand(value))

    unit = [
      I18n.t("units.currency.#{ scale }"),
      I18n.t("units.man_years.unit")
    ].join('/')

    @update_subheader "(#{ unit })"

  # An item can be unvailable when it's dependent on e.g. Merit being enabled
  render_unavailable: () =>
    $('strong', @dom_id).empty().append(I18n.t('units.unavailable'))
    @cleanArrows()
    @element.addClass('unavailable')

  update_header: (title) =>
    $('.header', @dom_id).html(title)

  update_subheader: (title) =>
    $('.header .sub_header', @dom_id).html(title)

  open_popup: (e) =>
    e.preventDefault()

    $.fancybox.open
      href:     $(@dom_id).attr('href')
      autoSize: false
      type:     'ajax'
      width:    720
      height:   540
      padding:  0
      beforeClose: ->
        # don't leave stale charts around!
        charts.prune()

  # Formats the result of calculate_result() for the end-user
  format_result: () =>
    result = @model.result()
    key    = @model.get('key')
    return '' if @model.error()
    return 'unavailable' if result == 'unavailable'

    out = switch key
      when 'total_energy_cost'
        # One decimal place when billions, two when trillions.
        precision = if result < 1000 then 1 else 2
        Metric.euros_to_string(result * 1000000000, null, precision)
      when 'costs_fte'
        Metric.euros_to_string(result)
      when 'household_energy_cost'
        I18n.toCurrency(result, { precision: 0, unit: '&euro;' })
      when 'total_primary_energy', 'employment', 'co2_reduction', 'local_co2_reduction', 'co2_reduction_relative_to_start_year', 'all_ghg_reduction_relative_to_start_year'
        # show + prefix if needed
        Metric.ratio_as_percentage(result, true)
      when 'net_energy_import', 'profitability'
        # 1 point precision
        Metric.ratio_as_percentage(result, false, 1)
      when 'biomass_primary_demand','biomass_final_demand'
        Metric.autoscale_value(result, @model.gquery.get('unit'), 1)
      when 'renewable_percentage'
        Metric.ratio_as_percentage(result)
      when 'renewable_percentage_households'
        Metric.ratio_as_percentage(result)
      when 'renewable_electricity_percentage'
        Metric.ratio_as_percentage(result)
      when 'biomass_import_share'
        Metric.ratio_as_percentage(result)
      when 'bio_footprint'
        formatted = "#{Metric.round_number(result, 1)}x"
        if App.settings.get_scaling()
          formatted
        else
          "#{formatted}#{App.settings.country().toUpperCase()}"
      when 'loss_of_load', 'power_shortage_hours', 'total_number_of_excess_events'
        "#{Metric.round_number(result, 0)} #{I18n.t('units.hours')}"
      when 'total_curtailment'
        Metric.autoscale_value(result, @model.gquery.get('unit'), 1)
      when 'share_of_curtailment'
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

    return false unless diff && Math.abs(diff)

    if diff > 0
      newClass = 'arrow_up'
    else if diff < 0
      newClass = 'arrow_down'
    else
      newClass = 'arrow_neutral'

    arrow_element.addClass(newClass)
    arrow_element.css('opacity', 1.0)

    # make sure the arrows take their original form after 30 seconds
    Util.cancelableAction("updateArrows #{@model.get('key')}",
      => arrow_element.animate({opacity: 0.0}, 1000),
      {'sleepTime': 30000}
    )

  cleanArrows:() =>
    arrow_element = $('.arrow', @dom_id)
    arrow_element.removeClass('arrow_neutral arrow_down arrow_up')
