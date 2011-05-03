$(document).ready(function(){
  $("input[name='country']").change(function(){
    var country = $("input[name='country']:checked").val(); //param for country
    var url = "/pages/update_footer/?country="+country;
    $.ajax({ 
      url: url+"&"+timestamp(), // appending now() prevents the browser from caching the request
      method: 'get', // use GET requests. otherwise chrome and safari cause problems.
      success: function(data){
        $("#logos").replaceWith(data);//update html
          call_the_cyclists();
      }
    });
  });
  call_the_cyclists();
});

function call_the_cyclists(){
  $("#logos ul.left").cycle({
    speed: 500,
    timeoutFn: function(curr,next,opts,fwd) {
      var timeout = $(this).attr('timeout');
      return parseInt(timeout,10);
    }
  });
  $("#logos ul.right").cycle({
    speed: 500,
    random: 1,
    notRandomFirst: 0, //my own addition to the Cycle plugin! DS
    timeoutFn: function(curr,next,opts,fwd) {
      var timeout = $(this).attr('timeout');
      return parseInt(timeout,10);
    }
  });
}