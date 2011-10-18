$(document).ready(function(){
  console.log('ready')
  $('#output_element_serie_color').live('change',function(){      
    $('.color_hint').css("background-color",$(this).attr('value'));
  });
});