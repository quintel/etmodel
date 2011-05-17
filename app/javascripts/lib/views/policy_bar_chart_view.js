
var PolicyBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    // SEB: maybe needs a better way to remove jqplot objects.
    //      => possible js memory leak
    $('#current_chart').empty().css('height', this.HEIGHT);

    console.log(this.result_serie1());
    console.log(this.result_serie2());
    console.log(this.ticks());
    console.log(this.model.colors());
    console.log(this.model.labels());
    console.log(this.axis_scale());
    //function InitializePolic  yBar(id,serie1,serie2,ticks,groups,unit,axis_values,colors,labels){
    InitializePolicyBar("current_chart", 
      this.result_serie1(), 
      this.result_serie2(), 
      this.ticks(), 
      this.model.series.length, 
      // DEBT: not correctly implemented
      '%', //this.parsed_unit(), 
      this.axis_scale(),
      this.model.colors(), 
      this.model.labels());
  },

  result_serie1 : function() {
    return _.flatten(this.model.value_pairs());
  },

  result_serie2 : function() {
    return _.map(this.result_serie1(), function(r) {
      return 100 - r;
    });
  },

  ticks : function() {
    var ticks = [];
    this.model.series.each(function(serie) {
      ticks.push([ serie.result()[0][0] ]);
      ticks.push([ serie.result()[1][0] ]);
    });
    return ticks;
  } 
});