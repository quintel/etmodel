$(document).ready(function() {

  $("input.pick_prediction").live('click',function () {
    var slider_id = $(this).parents('a:first').attr('id').match(/\d+$/);
    var prediction_id = $(this).attr('data-prediction_id');
    var url = "";
    if ($(this).is(':checked')) {
      url = "/expert_predictions/set_prediction/"+slider_id+"?prediction_id="+prediction_id;
    }
    else {
      url = "/expert_predictions/reset_prediction/"+slider_id;
    }
    $.ajax({ 
      url: url,
      method: 'get',// use GET requests. otherwise chrome and safari cause problems.
      async: false
    });
  });
});