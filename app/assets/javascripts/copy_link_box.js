// Functions to toggle the copy link box for sharing
// a scenario on the saved scenario page
$(document).ready( function() {
  $('.copy_link a').click(function() {
    $('.copy_box').show();
    $('.url input').focus();
  });
  $('.cross').click(function() {
    $('.copy_box').hide();
  });
});
