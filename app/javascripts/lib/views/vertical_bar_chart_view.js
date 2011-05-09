
var VerticalBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    // SEB: maybe needs a better way to remove jqplot objects.
    //      => possible js memory leak
    $('#current_chart').empty().css('height', this.HEIGHT);

    // function InitializeVerticalBar(id,series,ticks,filler,show_point_label,unit,axis_values,colors,labels){
    
    InitializeVerticalBar("current_chart", 
      this.results(), 
      this.ticks(),
      this.filler(),
      true ,
      this.parsed_unit(), // this.parsed_unit(smallest_scale)
      this.axis_scale(),
      this.model.colors(),
      this.model.labels());
  },

  results : function() {
    return [[1,2,3]];
  },

  ticks : function() {
    return ['2010', '2040'];
  },
  filler : function() {
    return [];
  },
  parsed_unit : function() {
    return 'PJ';
  },
  axis_scale : function() {
    return [0,10];
  }
});