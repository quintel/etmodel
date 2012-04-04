/* DO NOT MODIFY. This file was compiled Wed, 04 Apr 2012 13:29:13 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/block_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BlockChartView = (function(_super) {

    __extends(BlockChartView, _super);

    function BlockChartView() {
      this.render = __bind(this.render, this);
      BlockChartView.__super__.constructor.apply(this, arguments);
    }

    BlockChartView.prototype.initialize = function() {
      this.initialize_defaults();
      return this.setup_callbacks();
    };

    BlockChartView.prototype.render = function() {
      $("a.select_chart").hide();
      $("a.toggle_chart_format").hide();
      this.setup_checkboxes();
      return update_block_charts(this.model.series.map(function(serie) {
        return serie.result();
      }));
    };

    BlockChartView.prototype.can_be_shown_as_table = function() {
      return false;
    };

    BlockChartView.prototype.setup_callbacks = function() {
      bind_hovers();
      return $('.show_hide_block').click(function() {
        var block_id;
        block_id = $(this).attr('data-block_id');
        toggle_block(block_id);
        align_checkbox(block_id);
        return false;
      });
    };

    BlockChartView.prototype.setup_checkboxes = function() {
      var item, _i, _len, _ref, _results;
      _ref = $(".block_list_checkbox");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if ($(item).parent().find('.visible').length > 0) {
          _results.push($(item).attr('checked', true));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    
  
//global variables

var current_z_index = 5;
var global_data_array = [];

$(document).ready(function(){

  $('.block_list_checkbox').click(function(){
    if( $(this).is(':checked') ){
      $(this).parent().find('.show_hide_block').each(function(){
        var block_id = $(this).attr('data-block_id');
        show_block(block_id);
      });
    }
    else{
      $(this).parent().find('.show_hide_block').each(function(){
        var block_id = $(this).attr('data-block_id');
        hide_block(block_id);
      });
    }
  })
});


//global functions

function toggle_block(block_id){
  if ( $('#canvas').find('#block_container_'+block_id).hasClass('visible') ) {
    hide_block(block_id);
  } else {
    show_block(block_id);
  }
};

function show_block(block_id) {         
  $('#canvas').find('#block_container_'+block_id).removeClass('invisible').
    addClass('visible').css({'z-index':current_z_index});

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
    if ($('#block_container_'+block[0]).hasClass('visible')) {
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
  ;

    return BlockChartView;

  })(BaseChartView);

}).call(this);
