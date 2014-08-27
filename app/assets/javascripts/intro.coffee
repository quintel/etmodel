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

  areaOnChange = ->
    # "Standard" years.
    sYearSelect = $("#new_scenario select[name=end_year]")

    # Custom years.
    cYearSelect = $("#new_scenario select[name=other_year]")

    earliest = areaSelect.find(':selected').data('earliest')
    standard = sYearSelect.find('option').map (i, o) -> parseInt(o.value, 10)
    latest   = _.max(standard)
    selected = parseInt(cYearSelect.find('option:selected').val(), 10)

    cYearSelect.empty()

    for year in [earliest..latest]
      cYearSelect.append($("<option value='#{ year }'>#{ year }</option>"))

    cYearSelect.val(selected)

  areaSelect.change(areaOnChange).change()
