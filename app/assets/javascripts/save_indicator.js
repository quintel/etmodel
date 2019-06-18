save_indicator = function(){
  $("a.save-scenario").click(function(){
    $("body").addClass("is-saving")
    window.Interface.close_all_menus()
  })
}

$(document).ready(save_indicator);
