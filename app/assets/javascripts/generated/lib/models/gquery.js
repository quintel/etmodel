/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/models/gquery.coffee
 */

(function() {
  var GqueryList,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.Gquery = (function(_super) {

    __extends(Gquery, _super);

    function Gquery() {
      Gquery.__super__.constructor.apply(this, arguments);
    }

    Gquery.prototype.initialize = function() {
      return window.gqueries.add(this);
    };

    Gquery.prototype.result = function() {
      var future_value, present_value;
      present_value = this.get('present_value');
      future_value = this.get('future_value');
      if (!this.is_acceptable_value(present_value) && !this.is_acceptable_value(future_value)) {
        console.warn("Gquery " + (this.get('key')) + ": " + present_value + "/" + future_value + ", reset to 0");
        present_value = 0;
        future_value = 0;
      }
      return [[this.get('present_year'), present_value], [this.get('future_year'), future_value]];
    };

    Gquery.prototype.future_value = function() {
      return this.get('future_value');
    };

    Gquery.prototype.present_value = function() {
      return this.get('present_value');
    };

    Gquery.prototype.handle_api_result = function(api_result) {
      if (!(api_result instanceof Array)) {
        return this.set({
          present_value: api_result,
          future_value: api_result,
          value: api_result,
          result_type: 'scalar'
        });
      } else {
        return this.set({
          present_year: api_result[0][0],
          present_value: api_result[0][1],
          future_year: api_result[1][0],
          future_value: api_result[1][1],
          result_type: 'array'
        });
      }
    };

    Gquery.prototype.is_acceptable_value = function(n) {
      var x;
      if (_.isBoolean(n)) return true;
      x = parseInt(n, 10);
      return _.isNumber(x) && !_.isNaN(x);
    };

    return Gquery;

  })(Backbone.Model);

  GqueryList = (function(_super) {

    __extends(GqueryList, _super);

    function GqueryList() {
      GqueryList.__super__.constructor.apply(this, arguments);
    }

    GqueryList.prototype.model = Gquery;

    GqueryList.prototype.with_key = function(gquery_key) {
      var _this = this;
      return this.filter(function(gquery) {
        return gquery.get('key') === gquery_key;
      });
    };

    GqueryList.prototype.keys = function() {
      var keys;
      keys = window.gqueries.map(function(gquery) {
        return gquery.get('key');
      });
      return _.compact(keys);
    };

    return GqueryList;

  })(Backbone.Collection);

  window.gqueries = new GqueryList;

}).call(this);
