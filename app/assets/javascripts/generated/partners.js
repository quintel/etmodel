/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 13:47:43 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/partners.coffee
 */

(function() {

  $(function() {
    $(".partner_link").mousemove(function(e) {
      var id, left, offset, top;
      offset = $("#partners").offset();
      top = e.pageY - offset.top + 10;
      left = e.pageX - offset.left + 10;
      id = $(this).attr("id");
      return $("#" + id + "_content").css({
        "top": top,
        "left": left
      });
    });
    return $(".partner_link").hover(function() {
      return $("#" + $(this).attr("id") + "_content").show();
    }, function() {
      return $("#" + $(this).attr("id") + "_content").hide();
    });
  });

}).call(this);
