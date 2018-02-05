/* globals d3 */
(function () {
  var chartDefaults = {
    margin: {
      top: 10,
      right: 0,
      bottom: 25,
      left: 60
    },
    formatValue: function (value) {
      return value;
    }
  };

  /**
   * Given a collection of series, returns an array of objects which describes
   * the vertical (y) values of each member so that it may be rendered by D3.
   */
  function seriesToRender(series) {
    var y0 = 0;

    return series.map(function (serie) {
      return Object.assign({}, serie, { y0: y0, y1: (y0 += +serie.value) });
    });
  }

  /**
   * Creates a horizontal scale.
   */
  function xScale(width, title) {
    return d3.scale
      .ordinal()
      .rangeRoundBands([0, width], 0.4) // second param adjusts bar width
      .domain([title]);
  }

  /**
   * Creates a vertical scale which derives its maximum value from the sum of
   * the values in the series.
   */
  function yScale(height, series) {
    return d3.scale
      .linear()
      .range([height, 0])
      .domain([
        0,
        d3.sum(
          series.map(function (serie) {
            return serie.value;
          })
        )
      ])
      .nice();
  }

  /**
   * Horizontal axis for the D3 chart. Requires a scale.
   */
  function xAxis(scale) {
    return d3.svg
      .axis()
      .scale(scale)
      .tickSize(5, 0, 0)
      .orient('bottom');
  }

  /**
   * Vertical axis for the D3 chart. Requires a scale.
   */
  function yAxis(scale, tickFormat) {
    return d3.svg
      .axis()
      .scale(scale)
      .orient('left')
      .ticks(5)
      .tickSize(6, 6, 0)
      .tickFormat(tickFormat);
  }

  /**
   * Renders a static bar chart in the given CSS "selector" using the
   * "userSettings" provided.
   *
   * "userSettings" must contain a key "series" describing the series to be
   * plotted. This will be an array of objects, each object having "key",
   * "value", and "color". Optional "margin", "width", and "height" keys may be
   * provided.
   */
  function stackedBarChart(selector, userSettings) {
    var element = d3.select(selector)[0][0];

    var settings = Object.assign(
      { width: element.clientWidth, height: element.clientHeight },
      chartDefaults,
      userSettings
    );

    var innerHeight =
      settings.height - settings.margin.top - settings.margin.bottom;

    var innerWidth =
      settings.width - settings.margin.left - settings.margin.right;

    var x = xScale(innerWidth, settings.title);
    var y = yScale(innerHeight, settings.series);

    var svg = d3
      .select(selector)
      .append('svg')
      .attr('width', settings.width)
      .attr('height', settings.height)
      .append('g')
      .attr(
        'transform',
        'translate(' + settings.margin.left + ',' + settings.margin.top + ')'
      );

    // Render each column; this implementation permits only one.
    var column = svg
      .selectAll('.column')
      .data([{ key: settings.title, data: seriesToRender(settings.series) }])
      .enter()
      .append('g')
      .attr('class', 'column')
      .attr('transform', function (d) {
        return 'translate(' + x(d.key) + ',0)';
      });

    // Render each series within each column.
    column
      .selectAll('rect')
      .data(function (d) {
        return d.data;
      })
      .enter()
      .append('rect')
      .attr('width', x.rangeBand())
      .attr('y', function (d) {
        return y(d.y1);
      })
      .attr('height', function (d) {
        return y(d.y0) - y(d.y1);
      })
      .style('fill', function (d) {
        return d.color;
      });

    // Append axis last so that they are displayed above the series.
    svg
      .append('g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + innerHeight + ')')
      .call(xAxis(x));

    svg
      .append('g')
      .attr('class', 'y axis')
      .call(yAxis(y, settings.formatValue));
  }

  window.stackedBarChart = stackedBarChart;
}());
