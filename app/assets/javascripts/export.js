/* globals I18n $*/

$(function () {
  var exportForm = $('form#export_esdl');

  if (exportForm.length > 0) {
    bindSubmitToForm(exportForm);
  }
});

function bindSubmitToForm(form) {
  form.find('.submit').on('click', function () {
    if (esdlSubmitChecks(form)) {
      form.trigger('submit');
    }
  });
}

function esdlSubmitChecks(form) {
  var mondaine_drive = $('.mondaine_drive');

  // If no Mondaine Drive, remove value to be sure
  if (mondaine_drive.length == 0 || mondaine_drive.is(':hidden')) {
    form.find('input[name=mondaine_drive_path]').val('');
    return true;
  }

  // If we want to export to Mondaine Drive, give a warning if no folder was selected
  if (form.find('input[name=mondaine_drive_path]').val() == '') {
    mondaine_drive.append(
      $('<div></div>').text(I18n.translate('export.esdl.select_folder')).addClass('warning')
    );

    return false;
  }

  return true;
}

function setupMondaineDriveListeners() {
  var form = $('form#export_esdl');

  // Setup browse functionality. See esdl.js
  browseMondaineDrive(form, true);

  bindSubmitToForm(form);

  // bind click to back
  $('#export_esdl .back').on('click', function () {
    $('.options').show();
    $('.mondaine_drive').hide();

    // remove mondaine drive options from form
    $('.selected').removeClass('selected');
    form.find('input[name=mondaine_drive_path]').val('');
  });
  // unbind href to browse option
  $('.option.browse').on('click', function () {
    $('.options').hide();
    $('.mondaine_drive').show();
    return false;
  });
}
