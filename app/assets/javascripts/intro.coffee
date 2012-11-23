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

  $('#existing_scenario li').hover ->
    $("#existing_scenario li").removeClass('active')
    $(this).addClass('active')
    $("#load_existing_scenario  #description  #text").html($(this).data 'description')
    # update the hidden input, too
    scenario_id = $(this).closest('li').data('scenario-id')
    $("#load_existing_scenario input#id").val scenario_id
    $("#load_existing_scenario").show()

  $("#existing_scenario li").click (e) ->
    e.preventDefault()
    scenario_id = $(e.target).closest('li').data('scenario-id')
    $("#load_existing_scenario input#id").val scenario_id
    $("#load_existing_scenario form").submit()
