function notify_grid_investment_needed(parts) {
  $.fancybox({
    width   : 960,
    padding : 30,
    href    : '/pages/grid_investment_needed?parts=' + parts,
    type    : 'ajax',
    onComplete: function() {$.fancybox.resize();}
  });
}

function disable_peak_load_tracking() {
  $("#track_peak_load_settings").attr('checked', false);
  toggle_peak_load_tracking();
}

function toggle_peak_load_tracking(){
  var track = $("#track_peak_load_settings").is(':checked');
  var url = "/settings/update/";
  $.ajax({ 
    url: url+"?"+timestamp()+"&track_peak_load="+track, // appending now() prevents the browser from caching the request
    method: 'get',
    beforeSend: function(){close_fancybox();}
  });
}