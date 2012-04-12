function timestamp() {
  return new Date().getTime();
}

function set_active_tab(page){
  $(".tabs li").removeClass('active');
  $(".tabs li#"+page).addClass('active');
}

// Checks the select tag to show custom year field select when
// other is clicked.
function check_year_radio_buttons() {
  var elements = $('#end_year option:selected');
  if(elements.text() == 'other'){
    $('#other_year').show();
  } else {
    $('#other_year').hide();
  }
}
