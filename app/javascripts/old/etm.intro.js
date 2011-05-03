$(document).ready(function() {
  $('#textrepository #home').html($('#text').html());
  
  $('#diamond-container a#home').hide();
   
  $('.diamond, a#home').hover(
    function () {
      var id_name = $(this).attr('id');
      //clean up actives
      $('#diamonds .active').removeClass('active');
      //update diamond
      $('#diamonds #'+id_name).addClass('active');

      //change text
      var new_html = $('#textrepository_'+id_name).html();
      $('#text').html(new_html);
      //show zoom out button
      if (id_name != 'home'){
        $('#diamond-container a#home').show();//fadeIn('slow');
      }
      else{
        $('#diamond-container a#home').hide();//fadeOut('fast');
      };
    }
  );

  //barcharts intro in demand
  //TO DO: (1) Make this dynamic (2) Make the code clean
  $('#sidebar li').hover(
    function(){
      //update blocks
      var id_name = $(this).attr('id');
      //clean up actives
      // $('#blocks li, #sidebar ul li').removeClass('active');
      $('#blocks li').removeClass('active');
      //make current one active
      // $('#sidebar li#'+id_name).addClass('active');
      $('#blocks li.'+id_name).addClass('active');
    }
  );
  
  $('#blocks li').hover(
    function(){
      //update blocks
      var id_name = $(this).attr('class');
      //clean up actives
      $('#blocks li, #sidebar ul li').removeClass('active');
      //make current one active
      $('#sidebar li#'+id_name).addClass('active');
      $('#blocks li.'+id_name).addClass('active');
    }
  );
  // used in root form
  $("#scenarios_select").change(function () {
    //show description
    $('.description, #level_select').hide(50);
    var scenario_id = $(this).find("option:selected").attr('value');
    $("#description_"+scenario_id).show(100);
    //show level selector
    if (scenario_id > 0) {
      $('#level_select').show(50);
      $('#go_button').show(50);
    }
  });

  $("#end_year_custom").click(function(){    
    $("input#end_year_custom_value").focus();
  });

  $("#end_year_custom_value").focus(function(){
    $("#end_year_custom").attr('checked', true);
  })
  .blur(function(){
    //put check here to see whether or not the value is > 2020 and < 2100 and alert otherwise
  });

  $("#new_scenario_button").click(function(e) {          
    $("#new_scenario_form").slideToggle();
    $("#existing_scenario_form").hide();
  });
  $("#existing_scenario_button").click(function(e) {          
    $("#existing_scenario_form").slideToggle();
    $("#new_scenario_form").hide();
  });

});

// used in root form
function select_netherlands() {
  $('#country_nl').attr('checked', true);
}


