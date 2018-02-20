/* globals d3 I18n */
(function() {
  var chartDefaults = {
    barPadding: 0.45,
    formatValue: function(value) {
      return value;
    },
    margin: {
      top: 10,
      right: 0,
      bottom: 25,
      left: 60
    },
    showY: true,
    title: ''
  };

  /**
   * Given a collection of series, returns an array of objects which describes
   * the vertical (y) values of each member so that it may be rendered by D3.
   */
  function seriesToRender(series) {
    var y0 = 0;

    return series.map(function(serie) {
      var value = Math.max(0, serie.value);

      var withCoordinates = Object.assign({}, serie, {
        y0: y0,
        y1: (y0 += value),
        value: value
      });

      return withCoordinates;
    });
  }

  /**
   * Creates a horizontal scale.
   */
  function xScale(width, title, barPadding) {
    return d3.scale
      .ordinal()
      .rangeRoundBands([0, width], barPadding) // second param adjusts bar width
      .domain([title]);
  }

  /**
   * Creates a vertical scale which derives its maximum value from the sum of
   * the values in the series.
   */
  function yScale(height, series, max) {
    return d3.scale
      .linear()
      .range([height, 0])
      .domain([
        0,
        max ||
          d3.sum(
            series.map(function(serie) {
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
   * Draw labels describing each series to the left of the rect.
   */
  function drawLabels(svg, y, series) {
    series.forEach(function(data) {
      var top = y(data.y1);
      var bottom = y(data.y0);

      if (bottom - top < 0.1) {
        // Don't draw label for any item too small to show.
        return;
      }

      svg
        .append('g')
        .append('svg:text')
        .text(I18n.t('factsheet.series.' + data.key))
        .style('fill', data.color)
        .attr(
          'transform',
          'translate(8,' + (top + (bottom - top) / 2 + 4) + ')'
        );
    });
  }

  /**
   * On series with an "icon", draws the matching SVG icon in the middle of the
   * bar, provided the bar is tall enough.
   */
  function drawIcons(svg, x, y, allSeries) {
    allSeries.forEach(function(series) {
      if (!series.icon) {
        return;
      }

      d3.xml(series.icon, 'image/svg+xml', function(xml) {
        var imported = document.importNode(xml.documentElement, true);

        var top = y(series.y1);
        var bottom = y(series.y0);

        if (bottom - top < 26) {
          // do not render icons on series too small to show them
          return;
        }

        svg.selectAll('g.series.' + series.key).each(function() {
          var cloned = imported.cloneNode(true);

          d3
            .select(cloned)
            .attr('width', '24px')
            .attr('height', '24px')
            .attr('x', x.rangeBand() / 2 - 12 + 'px')
            .attr('y', top + (bottom - top) / 2 - 12 + 'px')
            .select('path, polygon')
            .style('fill', '#FFF')
            .style('shape-rendering', 'auto');

          this.appendChild(cloned);
        });
      });
    });
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

    var x = xScale(innerWidth, settings.title, settings.barPadding);
    var y = yScale(innerHeight, settings.series, settings.max);

    var series = seriesToRender(settings.series);

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
      .data([{ key: settings.title, data: series }])
      .enter()
      .append('g')
      .attr('class', 'column')
      .attr('transform', function(d) {
        return 'translate(' + x(d.key) + ',0)';
      });

    // Render each series within each column.
    column
      .selectAll('g.series')
      .data(function(d) {
        return d.data;
      })
      .enter()
      .append('g')
      .attr('class', function(d) {
        return 'series ' + d.key;
      })
      .append('rect')
      .attr('width', x.rangeBand())
      .attr('y', function(d) {
        return y(d.y1);
      })
      .attr('height', function(d) {
        return y(d.y0) - y(d.y1);
      })
      .style('fill', function(d) {
        return d.color;
      });

    // Append axis last so that they are displayed above the series.
    svg
      .append('g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + innerHeight + ')')
      .call(xAxis(x));

    if (settings.showY) {
      svg
        .append('g')
        .attr('class', 'y axis')
        .call(yAxis(y, settings.formatValue));
    }

    if (settings.drawLabels) {
      drawLabels(svg, y, series);
    }

    drawIcons(svg, x, y, series);
  }

  window.stackedBarChart = stackedBarChart;
})();
