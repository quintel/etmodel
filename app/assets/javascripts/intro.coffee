$ ->
  $("#new_scenario_button").click (e) ->
    e.preventDefault()
    $("#new_scenario_button").addClass('active')
    $("#existing_scenario_button").removeClass('active')
    $("#new_scenario").slideToggle().addClass('active')
    $("#existing_scenario").hide()
    $("#load_exsisting_scenario").hide()

  $("#existing_scenario_button").click (e) ->
    e.preventDefault()
    $("#existing_scenario_button").addClass('active')
    $("#new_scenario_button").removeClass('active')
    $("#existing_scenario").slideToggle().addClass('active')
    $("#new_scenario").hide().removeClass('active')

  $('#existing_scenario li').hover ->
    $("#existing_scenario li").removeClass('active')
    $(this).addClass('active')
    $("#load_exsisting_scenario  #description  #text").html($(this).data 'description')
    $("#load_exsisting_scenario input#id").val($(this).data 'scenario-id')
    $("#load_exsisting_scenario").show()

  $("#existing_scenario li").click (e) ->
    e.preventDefault()
    $("#load_exsisting_scenario form").submit()