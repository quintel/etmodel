//global variables

var current_z_index = 5;
var global_data_array = [];


$(document).ready(function(){

  bind_hovers();
  
  $('.show_hide_block').click(function(){
     //substract nummer from element id
     var block_id = $(this).attr('id').substring(16,999);
     toggle_block(block_id);
     align_checkbox(block_id);
     return false;
  });

  $('.block_list_checkbox').click(function(){
    if( $(this).is(':checked') ){
      $(this).parent().find('.show_hide_block').each(function(){
        var block_id = $(this).attr('id').substring(16,999);
        show_block(block_id);
      });
    }
    else{
      $(this).parent().find('.show_hide_block').each(function(){
        var block_id = $(this).attr('id').substring(16,999);
        hide_block(block_id);
      });
    }
  })
  //determine by children whether it should be checked when page is loaded
  .each(function(){ 
    if( $(this).parent().find('.visible').length > 0 ){
      $(this).attr('checked', true);
    }
  });

});


//global functions

function toggle_block(block_id){
  if ( $('#canvas').find('#block_container_'+block_id).hasClass('visible') ) {
    hide_block(block_id);
  }
  else{
    show_block(block_id);
  }
};

function show_block(block_id){
  $('#canvas').find('#block_container_'+block_id).removeClass('invisible').addClass('visible').css({'z-index':current_z_index});
  $('#block_list #show_hide_block_'+block_id).addClass('visible').removeClass('invisible');
  $.ajax({
   url: "/output_elements/visible/block_"+block_id,//+"&t="+timestamp(), // appending now() prevents the browser from caching the request
   method: 'post' // use GET requests. otherwise chrome and safari cause problems.
  });
  current_z_index++;  
  update_block_charts(global_data_array);
}

function hide_block(block_id){
  $('#canvas').find('#block_container_'+block_id).removeClass('visible').addClass('invisible');
  $('#block_list #show_hide_block_'+block_id).addClass('invisible').removeClass('visible');
  $.ajax({
   url: "/output_elements/invisible/block_"+block_id, // appending now() prevents the browser from caching the request
   method: 'post' // use GET requests. otherwise chrome and safari cause problems.
  });  
  update_block_charts(global_data_array);
}

function align_checkbox(block_id){
  var checkbox = $('#show_hide_block_'+block_id).parent().parent().parent().find('.block_list_checkbox');
  var list_blocks = $('#block_list #show_hide_block_'+block_id).parent().parent();
  
  if( list_blocks.find('.visible').length > 0 ){
    checkbox.attr('checked', true);
  }
  else{
    //checkbox should be unchecked
    $(this).parent().find(':checkbox').attr('checked', false);
    checkbox.attr('checked', false);
  }
}

function bind_hovers(){
  
  $('.block_container').hover(
    function (){
      $(this).addClass("hover").css({"z-index": current_z_index}).find(".content").stop().animate({width: '150px', height: '100px'}); //.find('.header').animate({'font-size': '16px'})
      $(this).addClass("hover").css({"z-index": current_z_index}).find(".header").stop().animate({width: '150px'}); 
      $(".block_container").stop().not(".hover");//.animate({"opacity":0.25},"slow");
      $("#tooltip").stop();//.animate({opacity: 0.7});
      current_z_index++;
    },
    function (){	
      $(this).removeClass("hover").find('.content').stop().animate({width:'75px', height: '0px'}); //.find('.header').animate({'font-size': '10px'})
      $(this).removeClass("hover").find('.header').stop().animate({width:'75px'}); 
      $(".block_container").stop();//.animate({"opacity":0.9},"fast");
      $("#tooltip").stop();//.animate({opacity: 0});
      }
    );

  $('#block_list li').hover(
    function(){
      $(this).find("ul").show(1);
    },
    function(){
      $(this).find("ul").hide(1);
    }
  );

}
function update_block_charts(data_array){
  // max values check
  global_data_array = data_array;
  var max_cost = 0;
  var max_invest = 0;
  $.each(data_array, function(index, block) {
    if ($('#block_container_'+block[0]).attr('class').match(/\bvisible/)){
      if (max_cost < block[1]) max_cost = block[1];
      if (max_invest < block[2]) max_invest = block[2];
    }
  });
  
  // minimal value check
  if (max_cost < 200) max_cost = 200;
  if (max_invest < 5) max_invest = 5;

  // update x axis
  var ticks = $('#x-axis li');
  var value;
  ticks.each(function(index,tick){
    value = (max_invest / 5) * (index + 1);
    $('#'+tick.id).text(Math.round(value));
  });
  
  // update x axis
  ticks = $('#y-axis li');
  ticks.each(function(index,tick){
    value = (max_cost / 5) * (5 - index);
    $('#'+tick.id).text(Math.round(value));
  });
  // update blocks
  $.each(data_array, function(index, block) {
    var block_bottom = block[1] * 100 / max_cost;
    var block_left = block[2] * 100 / max_invest;
    $('#block_container_'+block[0]).animate({'bottom': block_bottom + "%",'left': block_left + "%"});
  });
}