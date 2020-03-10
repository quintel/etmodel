// Functions to toggle the copy link box for sharing
// a scenario on the saved scenario page
$(document).ready( function() {
  $('.copy-link a').click(function() {
    $('.copy-box').show();
    $('.url input').focus();
  });
  $('.cross').click(function() {
    $('.copy-box').hide();
  });
});
