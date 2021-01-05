/* globals $*/

$(function() {
  var esdlForm = $('form#import_esdl');

  if (esdlForm.length) {
    esdlForm.submit(function(e) {
      var form = $(e.target);

      form.find('input[type=submit]').remove();
      form.find('.wait').show();
    });

    esdlForm.find('.upload_file').hover(
      function() {
        $('#mondaine_drive').addClass('soften');
      },
      function() {
        $('#mondaine_drive').removeClass('soften');
      }
    );
  }
});

$(function() {
  var mondaineDrive = $('#mondaine_drive');

  if (mondaineDrive.length) {
    if (mondaineDrive.hasClass('disabled')) {
      mondaineDrive.find('a').bind('click', false);
    } else {
      mondaineDrive.find('a').unbind('click', false);

      mondaineDrive.hover(
        function() {
          $('#import_esdl .upload_file').addClass('soften');
        },
        function() {
          $('#import_esdl .upload_file').removeClass('soften');
        }
      );
    }
  }
});
