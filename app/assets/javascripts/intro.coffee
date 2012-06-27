$ ->
  $('.diamond').hover ->
      id_name = $(this).attr('id')
      # clean up actives
      $('.diamonds .active').removeClass('active')
      # update diamond
      $('.diamonds #'+id_name).addClass('active')
      # change text
      new_html = $('#textrepository_'+id_name).html()
      $('.diamond_container .text').html(new_html)

  # used in root form to show the predefined scenarios descriptions
  $("#scenarios_select").change ->
    $('.description').hide(50)
    locale = $(this).data 'locale'
    scenario_id = $(this).val()
    # the scenario description record has two spans en/nl for the localized text
    # Using html tags in the db records should better be avoided
    $("#description_#{scenario_id}").show(100)
      .find("span.#{locale}").show()
    if scenario_id > 0
      $('#go_button').show(50)

  $("#new_scenario_button").click (e) ->
    e.preventDefault()
    $("#new_scenario_form").slideToggle()
    $("#existing_scenario_form").hide()

  $("#existing_scenario_button").click (e) ->
    e.preventDefault()
    $("#existing_scenario_form").slideToggle()
    $("#new_scenario_form").hide()