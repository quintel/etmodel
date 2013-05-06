$ ->
  $("#new_scenario_button").click (e) ->
    e.preventDefault()
    $("#new_scenario_button").addClass('active')
    $("#existing_scenario_button").removeClass('active')
    $("#new_scenario").slideToggle().addClass('active')
    $("#existing_scenario").hide()
    $("#load_existing_scenario").hide()

  $("#existing_scenario_button").click (e) ->
    e.preventDefault()
    $("#existing_scenario_button").addClass('active')
    $("#new_scenario_button").removeClass('active')
    $("#existing_scenario").slideToggle().addClass('active')
    $("#new_scenario").hide().removeClass('active')
