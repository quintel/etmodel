$ ->
  $('#textrepository #home').html($('#text').html())
  $('#diamond-container a#home').hide()
  $('.diamond, a#home').hover ->
      id_name = $(this).attr('id')
      # clean up actives
      $('#diamonds .active').removeClass('active')
      # update diamond
      $('#diamonds #'+id_name).addClass('active')
      # change text
      new_html = $('#textrepository_'+id_name).html()
      $('#text').html(new_html)
      # show zoom out button
      if id_name != 'home'
        $('#diamond-container a#home').show()
      else
        $('#diamond-container a#home').hide()

  # used in root form
  $("#scenarios_select").change ->
    # show description
    $('.description').hide(50)
    scenario_id = $(this).find("option:selected").attr('value')
    $("#description_"+scenario_id).show(100)
    if scenario_id > 0
      $('#go_button').show(50)

  $("#new_scenario_button").click (e) ->
    e.preventDefault()
    $("#new_scenario_form").slideToggle()
    $("#existing_scenario_form").hide()
    $("#energy_mixer_desc").hide()

  $("#existing_scenario_button").click (e) ->
    e.preventDefault()
    $("#existing_scenario_form").slideToggle()
    $("#new_scenario_form").hide()
    $("#energy_mixer_desc").hide()

  $("#energy_mixer_button").click (e) ->
    e.preventDefault()
    $("#energy_mixer_desc").slideToggle()
    $("#new_scenario_form").hide()
    $("#existing_scenario_form").hide()
