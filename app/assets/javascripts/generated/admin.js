/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 13:19:00 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/admin.coffee
 */

(function() {

  $(function() {
    return $('#output_element_serie_color').live('change', function() {
      return $('.color_hint').css("background-color", $(this).attr('value'));
    });
  });

}).call(this);
