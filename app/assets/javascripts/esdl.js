$(function() {
  var esdlForm = $('form#import_esdl');

  if (esdlForm.length) {
    esdlForm.submit(function(e) {
      var form = $(e.target)

      form.find('input[type=submit]').remove();
      form.find('.wait').show();
    });
  }
});
