$(function() { 
    // setup player without "internal" playlists 
    $f("player1", "/flash/flowplayer-3.2.6.swf", {
      clip: {
        baseUrl: 'http://energietransitiemodel.nl/assets', scaling: 'fit'
      }
       
    // use playlist plugin. again loop is true 
    });
    $f("player1").playlist("div.clips:first", {loop:true}); 
});

$(document).ready(function(){

	$(".clips .first").click();

	$(".clips a").bind("click", function(id){
		var str = $("#ps"+this.id).html();
		var str2 = $("#partner"+this.id).html();	
		$("#psContainer #ps").html(str);
		if(str2=="none"){
			$("#logo").html("").css({"opacity": 0});
		}
		else{
			$("#logo").html("<a class='partner' href='/partners/"+str2+"/'><div class='header'><img src='/images/partners/"+str2+".png' /></div></a>").css({"opacity": 1});	
		}
	});
});
