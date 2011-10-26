

var WaterfallChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
    this.HEIGHT = '460px';
  },

  render : function() {
    this.clear_container();
    InitializeWaterfall(this.model.get("container"), 
      this.results(), 
      this.model.get('unit'), 
      this.colors(), 
      this.labels());
  },

  colors : function() {
    var colors = this.model.colors();
    colors.push(colors[0]); // add the color of the first serie again to set a color for the completing serie
    return colors;
  },

  labels : function() {
    var labels = this.model.labels();
    // RD: USING ID's IS A MASSIVE FAIL!!
    labels.push(this.model.get('id') == 51 ? App.settings.get("end_year") : 'Total');
    return labels;
  },

  results : function() {
    var series = this.model.series.map(function(serie) { 
      var present = serie.result_pairs()[0]; 
      var future = serie.result_pairs()[1]; 
      if (serie.get('group') == 'value') {
        return present; // Take only the present value, as group == value queries only future/present 
      } else {
        return future - present;
      }
    });
    // TODO: Add scaling!
    return series;
  }  
});
