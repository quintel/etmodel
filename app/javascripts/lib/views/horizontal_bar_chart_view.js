
var HorizontalBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },
  render : function() {
    // SEB: maybe needs a better way to remove jqplot objects.
    //      => possible js memory leak
    $('#current_chart').empty().css('height', this.HEIGHT);
    InitializeHorizontalBar("current_chart", 
      this.model.results(), 
      true, 
      'PJ', 
      this.axis_scale(), 
      this.model.colors(), 
      this.model.labels());
  }
});

