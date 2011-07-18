//TODO: rename this file to a better suited name DS // file split up into etm.accordion/page_title/header_menu.js
var update_slide_pids = {};

// simply returns #<class_name>_<id>
// should be extended to converter class_name to snailcase
function dom_id(class_name, id, add_hash) {
  if (add_hash == false) { 
    return class_name+"_"+id; 
  } else { 
    return '#'+class_name+"_"+id;
  }
}

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

function hide_forever(id) {
  $.cookie("hide_"+id, true);$("#"+id).fadeOut(250);
}

function set_movies(){
  flowplayer("a.movies", "/flash/flowplayer-3.2.6.swf", {

  	screen:	{
  		bottom: 0	// make the video take all the height
  	},

  	// change the default controlbar to modern
  	plugins: {
  		controls: {
  			url: 'flowplayer.controls-3.2.4.swf',

  			backgroundColor: "transparent",
  			backgroundGradient: "none",
  			sliderColor: '#FFFFFF',
  			sliderBorder: '1.5px solid rgba(160,160,160,0.7)',
  			volumeSliderColor: '#FFFFFF',
  			volumeBorder: '1.5px solid rgba(160,160,160,0.7)',

  			timeColor: '#ffffff',
  			durationColor: '#535353',

  			tooltipColor: 'rgba(255, 255, 255, 0.7)',
  			tooltipTextColor: '#000000'
  		}
  	},
  	clip: {
      	autoPlay: true
    }
  });
}


function set_movie_mouse_overs() {
  set_mouse_over($("a.movies img.active"), $("a.movies img.mouseover"));
}

function set_mouse_over(active, mouseover) {
  active.mouseover(function() {
    active.hide();
    mouseover.show();
  });
  mouseover.mouseout(function() {
    active.show();
    mouseover.hide();
  });
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

$(document).ready(function() {

  $("input.select_group").live('click',function () {
    var groups = $(".select_group");
    var string ="";
    groups.each(function(index, element){
      if($("#"+element.id).is(':checked')){
        string += element.id.match(/\d+$/)[0]+",";        
      }
    });
    var url = "";
    if(window.location.href.split('=').length > 1){
      url = window.location.href.split('=')[0]+"="+string.substring(0, string.length - 1);

    }else{
      url = window.location.href+"?groups="+string.substring(0, string.length - 1);
    }
    window.location.href = url;

  });
  
  // This also causes the start pages to not work!! because there App is undefined!
  // sets the fce checkbox the the value that is stored in backbone
  if (window.App !== undefined){
    $("#use_fce_settings").attr('checked', App.settings.get('use_fce'));  
  }

});


