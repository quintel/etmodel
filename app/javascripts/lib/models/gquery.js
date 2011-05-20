var Gquery = Backbone.Model.extend({
  initialize : function() {
    window.gqueries.add(this);
  },

  result : function() {
    var present_value = this.get('present_value');
    var future_value = this.get('future_value');

    if ( !(this.is_acceptable_value(present_value) && this.is_acceptable_value(future_value))) {
      console.warn('Gquery "'+this.get('key')+'" has undefined/null values. ' + present_value + '/' + future_value + ", reset to 0");
      present_value = 0;
      future_value  = 0;
    }

    var result = [
      [this.get('present_year'), present_value], 
      [this.get('future_year'), future_value]
    ];

    return result;
  },

  /*
   * api_result is either 
   * - Number: when adding present:V(...)
   * - Array: normal GQL Queries
   */
  handle_api_result : function(api_result) {
    if (!(api_result instanceof Array)) { 
      this.set({
        present_value : api_result, future_value : api_result,
        value : api_result, result_type : 'scalar'});
    } else {
      this.set({
        present_year  : api_result[0][0], present_value : api_result[0][1],
        future_year   : api_result[1][0], future_value  : api_result[1][1],
        result_type : 'array'
      });
    }
  },
  
  is_acceptable_value : function(n) {
    if (_.isBoolean(n)) { return true; }
    var x = parseInt(n, 10);
    return ( _.isNumber(x) && !_.isNaN(x));
  }
});

var GqueryList = Backbone.Collection.extend({
  model : Gquery,

  with_key : function(gquery_key) {
    return this.filter(function(gquery){ return gquery.get('key') == gquery_key; });
  },

  keys : function() {
    var keys = window.gqueries.map(function(gquery) { return gquery.get('key') });
    return _.compact(keys);
  }
});
window.gqueries = new GqueryList;