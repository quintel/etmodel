$(document).ready(function() {
  // login menu
  $(".signin").click(function(e) {          
	  e.preventDefault();
    $("fieldset#signin_menu").toggle();
		$(".signin").toggleClass("menu-open");
  });
	$("fieldset#signin_menu").mouseup(function() {
		return false;
	});
	$(document).mouseup(function(e) {
		if($(e.target).parent("a.signin").length==0) {
			$(".signin").removeClass("menu-open");
			$("fieldset#signin_menu").hide();
		}
	});			
  // setting menu		
	$(".settings").click(function(e) {          
	  e.preventDefault();
    $("#settings_menu").toggle();
		$(".settings").toggleClass("menu-open");
  });
	$("#settings_menu").mouseup(function() {
		return false;
	});
	$(document).mouseup(function(e) {
		if($(e.target).parent("a.settings").length==0) {
			$(".settings").removeClass("menu-open");
			$("#settings_menu").hide();
		}
	});
	
	// setting menu		
	$(".information").click(function(e) {          
	  e.preventDefault();
    $("#information_menu").toggle();
		$(".information").toggleClass("menu-open");
  });
	$("#information_menu").mouseup(function() {
		return false;
	});
	$(document).mouseup(function(e) {
		if($(e.target).parent("a.information").length==0) {
			$(".information").removeClass("menu-open");
			$("#information_menu").hide();
		}
	});
	
	$("#disable_peak_load_tracking").live('click',function() {          
    disable_peak_load_tracking();
  });
});
		
