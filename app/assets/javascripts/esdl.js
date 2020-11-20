/* globals $ */

$(function() {
  var esdlForm = $('form#import_esdl');

  if (esdlForm.length) {
    esdlForm.submit(function(e) {
      var form = $(e.target);

      form.find('input[type=submit]').remove();
      form.find('.wait').show();
    });
  }
});

function startBrowsingMondaineDrive() {
  console.log($('.login_to_drive'));
  console.log('bleh');
  $('.login_to_drive').hide();
}
