$ ->
  return if $("#player1").length == 0
  # setup player without "internal" playlists
  $f("player1", "/flash/flowplayer-3.2.6.swf", {
    clip: {
      baseUrl: 'http://energietransitiemodel.nl/media', scaling: 'fit'
    }
  })
  $f("player1").playlist("div.clips:first", {loop:true})
	$(".clips .first").click()
	$(".clips a").bind "click", (id) ->
		str = $("#ps"+this.id).html()
		str2 = $("#partner"+this.id).html()
		$("#psContainer #ps").html(str)
		if str2=="none"
			$("#logo").html("").css({"opacity": 0})
		else
      text = "<a class='partner' href='/partners/#{str2}/'><div class='header'><img src='/assets/partners/#{str2}.png' /></div></a>"
			$("#logo").html(text).css({"opacity": 1})
