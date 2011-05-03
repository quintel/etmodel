$(document).ready(function() {
  $("#read_more").click(function(){
    $("#content_short").hide();
    $("#content_long").show("fast");
    $("#read_more").hide();
    return false;
  });
  $("#read_less, #con").click(function(){
    $("#content_long").hide("fast");
    $("#content_short").show();
    $("#read_more").show();
    return false;
  });
});