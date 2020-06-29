/* globals $ */

function addFormListeners() {
  $('.scenario').hide();
  resizeTextarea();
  $('.cancel').click(restore);
}

function resizeTextarea() {
  $('textarea').height('auto');
  $('textarea').height($('textarea').prop('scrollHeight'));
}

function restore() {
  $('form').remove();
  $('.scenario').show();
}
