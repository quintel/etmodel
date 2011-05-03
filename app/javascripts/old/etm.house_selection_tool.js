$(document).ready(function() {  

  $("#existing_houses").live('click', function() {
    show_existing_houses_tab();
  });
  
  $("#new_houses").live('click', function() {
    show_new_houses_tab();
  });
  
  $(".pick_label li").live('click', function() {  
    set_element = $(this).attr("id");
    $("div.label_description").hide();
    $("."+set_element).show("slow");
  });
});

function show_new_houses_tab() {  
  $("#existing_house_content").hide("slow");
  $("div.label_description").hide();
  $("#new_house_content").show("slow");
  set_active_tab('new_houses');   
};

function show_existing_houses_tab() {  
  $("#new_house_content").hide("slow");
  $("div.label_description").hide();
  $("#existing_house_content").show("slow");
  set_active_tab('existing_houses');
};




