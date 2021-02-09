/* globals $*/

$(function () {
  var exportForm = $('form#export_esdl');

  if (exportForm.length > 0) {
    bindSubmitToForm(exportForm);
  }
});

function bindSubmitToForm(form) {
  form.find('.submit').on('click', function () {
    form.trigger('submit');
  });
}

function setupMondaineDriveListeners() {
  browseMondaineDrive($('form#export_esdl'), true);

  bindSubmitToForm($('form#export_esdl'));
  // bind click to back
  $('#export_esdl .back').on('click', function () {
    $('.options').show();
    $('.mondaine_drive').hide();
  });
  // unbind href to browse option
  $('.option.browse').on('click', function () {
    $('.options').hide();
    $('.mondaine_drive').show();
    return false;
  });
}
