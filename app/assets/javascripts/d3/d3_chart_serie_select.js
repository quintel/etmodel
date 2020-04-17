var D3ChartSerieSelect = (function () {

  function createOptions(options){
    return options.map(function(option) {
      return '<option value=' + option + '>' +
      I18n.t("output_element_series.labels" + option) +
      '</option>';
    });
  }

  function buildSelectBox(options, updateChart){
    return $("<select/>")
      .addClass("d3-chart-date-select")
      .append(createOptions(options))
      .on('change', updateChart);
  }

  D3ChartSerieSelect.prototype = {
    selectBox: undefined,
    draw: function (updateChart) {
      this.selectBox = buildSelectBox(this.options, updateChart);
      this.scope.append(this.selectBox);
    }
  };

  function D3ChartSerieSelect(scope, options) {
    this.scope = $(scope);
    this.options = options;
  }

  return D3ChartSerieSelect;
}());
