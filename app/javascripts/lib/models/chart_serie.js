
var ChartSerie = Backbone.Model.extend({
  initialize : function() {
    var gquery = new Gquery({key : this.get('gquery_key')});
    this.set({gquery : gquery});
  },
  
  result : function() {
    return this.get('gquery').result();
  },
  result_pairs : function() {
    var result = this.result();
    return [result[0][1],result[1][1]];
  }
});

var ChartSeries = Backbone.Collection.extend({
  model : ChartSerie
})
