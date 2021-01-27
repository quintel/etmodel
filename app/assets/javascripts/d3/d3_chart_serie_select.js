/* globals _ $ I18n */

var D3ChartSerieSelect = (function () {
  /**
   * Takes an array of options and partitions them into two arrays.
   *
   * The first array contains the collection of all options which do not belong to a group. The
   * second contains two-element tuples, the first element being the localized group name, and the
   * second the sorted list of options belonging to that group.
   */
  function partitionOptionsByGroup(options) {
    var grouped = [];
    var ungrouped = [];

    options.forEach(function (option) {
      (option.group ? grouped : ungrouped).push(option);
    });

    var groupedCollection = Object.entries(
      _.groupBy(grouped, function (option) {
        return I18n.t('output_element_series.groups.' + option.group);
      })
    );

    groupedCollection.sort(function (a, b) {
      return a[0].localeCompare(b[0]);
    });

    return [ungrouped, groupedCollection];
  }

  function buildOption(option) {
    return (
      '<option value=' +
      option.match +
      '>' +
      (option.name || I18n.t('output_element_series.labels.' + option.match)) +
      '</option>'
    );
  }

  function createOptions(options) {
    var partitioned = partitionOptionsByGroup(options);
    var elements = [];

    partitioned[0].forEach(function (option) {
      elements.push(buildOption(option));
    });

    partitioned[1].forEach(function (group) {
      var groupName = group[0];
      var groupOptions = group[1];

      var optgroup = $('<optgroup />').attr('label', groupName);

      groupOptions.forEach(function (option) {
        optgroup.append(buildOption(option));
      });

      elements.push(optgroup);
    });

    return elements;
  }

  function buildSelectBox(options, updateChart) {
    return $('<select/>')
      .addClass('d3-chart-select')
      .addClass('d3-chart-serie-select')
      .append(createOptions(options))
      .on('change', updateChart);
  }

  D3ChartSerieSelect.prototype = {
    selectBox: undefined,

    draw: function (updateChart) {
      this.selectBox = buildSelectBox(this.options, updateChart);
      this.scope.append(this.selectBox);
    },
  };

  function D3ChartSerieSelect(scope, options) {
    this.scope = $(scope);
    this.options = options;
  }

  return D3ChartSerieSelect;
})();
