/* DO NOT MODIFY. This file was compiled Wed, 21 Mar 2012 08:24:57 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/sidebar_view.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.SidebarView = (function(_super) {

    __extends(SidebarView, _super);

    function SidebarView() {
      SidebarView.__super__.constructor.apply(this, arguments);
    }

    SidebarView.prototype.bootstrap = function() {
      var gquery, item, _i, _len, _ref, _results;
      _ref = $("#sidebar ul li");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        gquery = $(item).attr('data-gquery');
        if (gquery) {
          _results.push(new Gquery({
            key: gquery
          }));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    SidebarView.prototype.update_bars = function() {
      var gquery, item, key, padded_percentage, percentage, result, _i, _len, _ref;
      _ref = $("#sidebar ul li");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        key = $(item).attr('data-gquery');
        if (!key) continue;
        gquery = gqueries.with_key(key)[0];
        if (!gquery) return;
        result = gquery.get('future_value');
        percentage = "" + (Math.round(result * 100)) + "%";
        padded_percentage = "" + (Math.round(result * 90)) + "%";
        $(item).find(".bar").animate({
          width: padded_percentage
        });
        $(item).find(".value").html(percentage).animate({
          left: padded_percentage
        });
      }
    };

    return SidebarView;

  })(Backbone.View);

  window.sidebar = new SidebarView();

}).call(this);
