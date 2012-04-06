/* DO NOT MODIFY. This file was compiled Fri, 06 Apr 2012 13:03:31 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/testimonials.coffee
 */

(function() {

  $(function() {
    $f("player1", "/flash/flowplayer-3.2.6.swf", {
      clip: {
        baseUrl: 'http://energietransitiemodel.nl/assets',
        scaling: 'fit'
      }
    });
    return $f("player1").playlist("div.clips:first", {
      loop: true
    });
  });

  $(".clips .first").click();

  $(".clips a").bind("click", function(id) {
    var str, str2, text;
    str = $("#ps" + this.id).html();
    str2 = $("#partner" + this.id).html();
    $("#psContainer #ps").html(str);
    if (str2 === "none") {
      $("#logo").html("").css({
        "opacity": 0
      });
    } else {
      text = "<a class='partner' href='/partners/" + str2 + "/'><div class='header'><img src='/images/partners/" + str2 + ".png' /></div></a>";
    }
    return $("#logo").html(text).css({
      "opacity": 1
    });
  });

}).call(this);
