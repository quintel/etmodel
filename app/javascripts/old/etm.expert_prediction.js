$(document).ready(function() {

  $("input.pick_prediction").live('click',function () {
    var slider_id = $(this).parents('a:first').attr('id').match(/\d+$/);
    var prediction_id = $(this).attr('data-prediction_id');
    var url = "";
    if (prediction_id != 0) {
      url = "/expert_predictions/set?prediction_id=" + prediction_id + "&slider_id=" + slider_id;
    } else {
      url = "/expert_predictions/reset?slider_id=" + slider_id;
    }
    $.ajax({ 
      url: url,
      method: 'get',
      async: false
    });
  });
});