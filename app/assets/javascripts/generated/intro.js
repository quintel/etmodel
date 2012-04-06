/* DO NOT MODIFY. This file was compiled Fri, 06 Apr 2012 11:23:31 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/intro.coffee
 */

(function() {

  $(function() {
    $('#textrepository #home').html($('#text').html());
    $('#diamond-container a#home').hide();
    $('.diamond, a#home').hover(function() {
      var id_name, new_html;
      id_name = $(this).attr('id');
      $('#diamonds .active').removeClass('active');
      $('#diamonds #' + id_name).addClass('active');
      new_html = $('#textrepository_' + id_name).html();
      $('#text').html(new_html);
      if (id_name !== 'home') {
        return $('#diamond-container a#home').show();
      } else {
        return $('#diamond-container a#home').hide();
      }
    });
    $("#scenarios_select").change(function() {
      var scenario_id;
      $('.description').hide(50);
      scenario_id = $(this).find("option:selected").attr('value');
      $("#description_" + scenario_id).show(100);
      if (scenario_id > 0) return $('#go_button').show(50);
    });
    $("#new_scenario_button").click(function(e) {
      e.preventDefault();
      $("#new_scenario_form").slideToggle();
      $("#existing_scenario_form").hide();
      return $("#energy_mixer_desc").hide();
    });
    $("#existing_scenario_button").click(function(e) {
      e.preventDefault();
      $("#existing_scenario_form").slideToggle();
      $("#new_scenario_form").hide();
      return $("#energy_mixer_desc").hide();
    });
    return $("#energy_mixer_button").click(function(e) {
      e.preventDefault();
      $("#energy_mixer_desc").slideToggle();
      $("#new_scenario_form").hide();
      return $("#existing_scenario_form").hide();
    });
  });

}).call(this);
