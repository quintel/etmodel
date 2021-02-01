/* globals $*/

$(function () {
  var exportForm = $('form#export_esdl');

  if (exportForm.length > 0) {
    exportForm.find('.option').on('click', function () {
      exportForm.trigger('submit');
    });
  }
});
