var active_slide;
$(document).ready(function() {

  $('.accordion').each(function(i,el) {

    var selected_index = 0;
    $('li.accordion_element', this).each(function(i,el) { 
      if ($(el).is('.selected')) { selected_index = i; }
      $(el).show();
    });
    var accordion = {};
    if ($('li.accordion_element').length > 1){ 
        accordion = $(el).accordion({
        header: '.headline',
     		collapsible: true,
        fillSpace: false,
        autoHeight: false,
        active: false
      });
    } else {
      accordion = $(el).accordion({
        header: '.headline',
     		collapsible: true,
        fillSpace: false,
        autoHeight: false
      });
    }

    $('.ui-accordion').bind('accordionchange', function(ev,ui) {
      if (ui.newHeader.length > 0){
        var output_element_id = ui.newHeader.attr('id').match(/\d+$/);
        if (output_element_id != '32') {
          window.charts.load(output_element_id);
        }
      }
    });

    $(".slide").each(function(i, slide) { 
      $("a.btn-done", slide).filter(".next, .previous").click(function() { 
        accordion.accordion("activate",i + ($(this).is(".next") ? 1 : -1));
        return false;
      }); 
    });
  });
  
  if (active_slide){
    open_slide(active_slide);
  }
  
  
});

function open_slide(slide_title){
  $('li.accordion_element a.slide_header').each(function(i,el) { 
     if ($(el).attr('id') == slide_title){
       $('.ui-accordion').accordion( "activate" , i );
     }
   });
}

