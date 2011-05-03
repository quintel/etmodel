$(document).ready(function(){
  $(".partner_link").mousemove(function(e){
    var tipX = e.pageX; // - $(this).offset().left - $(window).scrollLeft();
    var tipY = e.pageY;// - $(window).scrollTop(); // 
    var offset = $("#partners").offset();
        // $("#"+$(this).attr("id") + "_content").css({"top": e.pageY, "left": e.pageX});
    $("#"+$(this).attr("id") + "_content").css({"top": (e.pageY - offset.top + 10), "left": (e.pageX - offset.left + 10)});
  });
  
  $(".partner_link").hover(function(){
      $("#"+$(this).attr("id") + "_content").show();
    }
    ,function(){
      $("#"+$(this).attr("id") + "_content").hide();
    }
  );

});


$(document).bind('mousemove',function(e){ 

});
function open_partner_boxes(partner) {
  close_all_partner_boxes();
  $('.constraint_popup', constraint).css('bottom', '80px');
  
  $('#shadowbox-outer', constraint).animate({opacity: 0.95}, 'slow');
  if ($('.loading', constraint).length == 1) {  
    $.get($(constraint).attr('rel')+"?t="+timestamp(), function(data) {
      $('#shadowbox-body', constraint).html(data);
    });      
  }
}

function close_all_partner_boxes() {
  $('.constraint_popup').css('bottom', '8000px');
}
