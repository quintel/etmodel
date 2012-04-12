function timestamp() {
  return new Date().getTime();
}

var canceable_action_pids = {};
function canceable_action(name, action, timeout) {
  cancel_action(name);
  canceable_action_pids[name] = setTimeout(action, timeout);
}
function cancel_action(name) {
  clearTimeout(canceable_action_pids[name]);
}

// Stores ids for timed events. So that they can be expired later.
var timed_event_pids = {};
// ev = Slider event: e.g. {elem : input element, value : 0.2}
function timed_event(ev) {
  var el = ev.elem;
  clearTimeout(timed_event_pids[el.name]);
  timed_event_pids[el.name] = setTimeout(function() {
  }, 300);
}

function set_active_tab(page){
  $(".tabs li").removeClass('active');
  $(".tabs li#"+page).addClass('active');
}

$("#how").live('click',function () {
  // $(".movie_content").hide();
  var url = "/select_movie/how";
  $.ajax({
    url: url+"?"+timestamp(),
    method: 'get'
  });
   return false;
});
$("#what").live('click',function () {
  // $(".movie_content").hide();
  var url = "/select_movie/what";
  $.ajax({
    url: url+"?"+timestamp(),
    method: 'get'
    // onComplete: function() {$(".movie_content").show();}
  });
   return false;
});


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
