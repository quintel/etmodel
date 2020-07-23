/* globals $ */

// eslint-disable-next-line no-unused-vars
function addFormListeners() {
  $('.scenario').hide();
  $('.load').addClass('dim');
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
  $('.load').removeClass('dim');
}

$(function() {
  if (!document.getElementById('unfeature')) {
    return;
  }

  $('#unfeature .check .save').on('click', function(event) {
    event.stopPropagation();
    $('#unfeature .check').hide();
    $('#unfeature .confirm').show();
  });

  resizeTextarea();
});
