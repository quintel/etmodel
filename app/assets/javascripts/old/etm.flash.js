function flash_notice(msg) {
  if ( $('#flash').length == 0 ) {
    $('#title').append("<div id='flash' class='notice'>" + msg + "</div>");
  }
  else {
    $('#flash').html(msg);
  }
  $('#flash').show().fadeOut(5000);
}