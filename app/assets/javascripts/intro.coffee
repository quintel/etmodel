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

  areaSelect = $("#new_scenario select[name=area_code]")
  sYearSelect = $("#new_scenario select[name=end_year]")
  cYearSelect = $("#new_scenario select[name=other_year]")

  areaSelect.chosen(search_contains: true)

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

    $("p.dataset_information a")
      .attr("href", "/regions/" + areaValue)
      .find(".link")
      .text(selectedOption.text())

  areaSelect.change(areaOnChange).change()

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
