$(document).ready(function() {
  $(".valuees a.label, a.fancybox").live('click', function() {
    $(this).fancybox({
      padding  : 20,
      titleShow: false,
      ajax : {
        type  : "GET"
      },
      onComplete: function() {
        setTimeout(function(){
          $.fancybox.resize();
        },100);
       $("#fancybox-inner").css({'overflow-x':'hidden'});
      }
    });

    $(this).trigger('click');
    return false;
  });


  $("a.tutorial_button").live('click', function() {

    $(this).fancybox({
      width    : 940,
      titleShow: false,
      padding  : 0,
      opacity: false,
      scrolling: 'no',
      ajax : {
        type  : "GET"
      },
      onComplete: function() {
       $("#fancybox-outer").css({'background':'transparent'});
       $(".fancy-bg").css({'display':'none'});
      },
      onClosed:function() {
       $("#fancybox-outer").css({'background':'white'});
       $(".fancy-bg").css({'display':'true'});
      }
    });

    $(this).trigger('click');
    // alert('hit');
    return false;
  });

  $("a.house_selection_tool").live('click', function() {

    $(this).fancybox({
      width    : 960,
      height   : 680,
      titleShow: false,
      padding  : 0,
      ajax : {
        type  : "GET"
      },
      onComplete: function() {
       $("#fancybox-inner").css({'overflow-x':'hidden'});
      }
    });

    $(this).trigger('click');
    return false;
  });

  $("a.select_chart").live('click', function() {

    $(this).fancybox({
      width    : 960,
      height   : 600,
      titleShow: false,
      padding  : 0,
      ajax : {
        type  : "GET"
      },
      onComplete: function() {
        $("#fancybox-inner").css({'overflow-x':'hidden'});
      }
    });

    $(this).trigger('click');
    return false;
  });

  $("a.expert_header").live('click', function() {

    $(this).fancybox({
      width    : 970,
      height   : 650,
      titleShow: false,
      padding  : 0,
      scrolling: 'no',
      ajax : {
        type  : "GET"
      }
    });

    $(this).trigger('click');
    return false;
  });

  $("a.prediction").live('click', function() {

    $(this).fancybox({
      width    : 960,
      height   : 650,
      titleShow: false,
      padding  : 0,
      type     : 'iframe',
      ajax : {
        type  : "GET"
      }

    });

    $(this).trigger('click');
    return false;
  });

  $(".energy_mixer").live('click', function() {

    $(this).fancybox({
      width    : 890,
      height   : "80%",
      titleShow: false,
      padding  : 0,
      scrolling: 'auto',
      type     : 'iframe',
      ajax : {
        type  : "GET"
      }
    });

    $(this).trigger('click');
    // alert('hit');
    return false;
  });


  $('#overlay_container a').live('click', function(i,el) {
    if (!$(this).hasClass('no_target')){
      window.open($(this).attr('href'), '_blank');
    }
    return null;
  });

});

function close_fancybox(){
  $.fancybox.close();
}
