$ ->
  $(".partner_link").mousemove (e) ->
    offset = $("#partners").offset()
    top = e.pageY - offset.top + 10
    left = e.pageX - offset.left + 10
    id = $(this).attr("id")
    $("##{id}_content").css({"top": top, "left": left})

  $(".partner_link").hover( ->
      $("#"+$(this).attr("id") + "_content").show()
    , ->
      $("#"+$(this).attr("id") + "_content").hide()
  )
