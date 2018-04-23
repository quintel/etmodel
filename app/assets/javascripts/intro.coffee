$ ->
  $("#new_scenario_button").click (e) ->
    e.preventDefault()
    newScenario = $('#new_scenario')

    $("#new_scenario_button").addClass('active')
    $("#existing_scenario_button").removeClass('active')

    unless newScenario.is(':visible')
      newScenario.slideDown
        duration: 175
        easing: 'easeOutQuad'

    newScenario.addClass('active')

    $("#existing_scenario").hide()
    $("#load_existing_scenario").hide()

  $("#existing_scenario_button").click (e) ->
    e.preventDefault()
    existingScenario = $('#existing_scenario')

    $("#existing_scenario_button").addClass('active')
    $("#new_scenario_button").removeClass('active')

    unless existingScenario.is(':visible')
      existingScenario.slideDown(600)

    existingScenario.addClass('active')
    $("#new_scenario").hide().removeClass('active')

  areaTemplate = (state) ->
    if !state.id
      return state.text

    root  = $("<span/>")
    flag  = $(".flags img.#{ state.id }").clone()
    inner = $("<span/>").text(state.text)

    if flag.length > 0
      root.append(flag)

    root.append(inner).attr('id', state.id)

  areaSelect = $("#new_scenario select[name=area_code]")

  # "Standard" years.
  sYearSelect = $("#new_scenario select[name=end_year]")

  # Custom years.
  cYearSelect = $("#new_scenario select[name=other_year]")

  areaSelect.select2(
    width: '231px',
    templateResult: areaTemplate,
    dropdownParent: $('#area-select-options'),
    dropdownAutoWidth : true
  )
  sYearSelect.select2(minimumResultsForSearch: -1, dropdownAutoWidth : true, width: 'auto')

  areaOnChange = ->
    earliest = areaSelect.find(':selected').data('earliest')
    standard = sYearSelect.find('option').map (i, o) -> parseInt(o.value, 10)
    latest   = _.max(standard)
    selected = parseInt(cYearSelect.find('option:selected').val(), 10)

    cYearSelect.empty()

    for year in [earliest..latest]
      cYearSelect.append($("<option value='#{ year }'>#{ year }</option>"))

    cYearSelect.val(selected)

    # Set dataset information
    areaValue = $(this).val()
    selectedOption = $(this).find("option[value='" + areaValue + "']")

    $(".dataset_information a")
      .attr("href", "/regions/" + areaValue)

  areaSelect.change(areaOnChange).change()

  setParamForEstablishmentShot = ->
    $('.dataset_information > a')[0].search = "end_year=#{ $(this).val() }"

  # Checks the select tag to show custom year field select when
  # other is clicked.
  checkYearRadioButtons = ->
    elements = $('#end_year option:selected')

    if elements.val() == 'other'
      cYearSelect
        .select2(minimumResultsForSearch: -1)
        .show()
        .change(setParamForEstablishmentShot)
        .change()

    else
      setParamForEstablishmentShot.call(this)

      if cYearSelect.hasClass('select2-hidden-accessible')
        cYearSelect.select2('destroy').hide()

  sYearSelect.change(checkYearRadioButtons).change()

  $("#new_scaled_scenario").submit ->
    variableEl = $("#new_scaled_scenario [name=scaling_value]")
    value      = $.trim(variableEl.val())

    if not value.length or parseInt(value, 10) is 0
      variableEl.addClass('error').focus()
      return false

    variableEl.removeClass('error')

  $("#scaled_scenario_setup .selection").on "click", (event) ->
    target = $(event.currentTarget)

    $("#scaled_scenario_setup .selection").removeClass("active")
    target.addClass("active")

    if target.hasClass('new')
      $("#new_scaled_scenario").show()
      $("#preset_scaled_scenario").hide()
    else
      $("#preset_scaled_scenario").show()
      $("#new_scaled_scenario").hide()

    event.preventDefault()
