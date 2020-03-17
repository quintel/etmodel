var D3ChartSerieSelect = (function () {

  function setChartSerie(){
    this.updateChart();
  }

  function createOptions(){
    var html_options = [];
    this.options.forEach(function(option) {
      html_options += '<option value=' + option + '>' +
                      I18n.t("output_element_series." + option) +
                      '</option>';
    });
    return html_options;
  }

  function buildSelectBox(){
    return $("<select/>")
      .addClass("d3-chart-date-select")
      .append(createOptions.call(this))
      .on('change', setChartSerie.bind(this));
  }

  D3ChartSerieSelect.prototype = {
    selectBox: undefined,
    draw: function (updateChart) {
      this.updateChart = updateChart;
      this.selectBox = buildSelectBox.call(this);

      this.scope.append(this.selectBox);
    }
  };

  function D3ChartSerieSelect(scope, options) {
    this.scope = $(scope);
    this.options = options;
  }

  return D3ChartSerieSelect;
}());
