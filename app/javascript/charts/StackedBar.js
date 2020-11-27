/* globals $ */

/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import * as d3 from 'd3';
import { transition } from 'd3';
import D3Chart from './D3Chart';

/**
 * Determines the opacity with which a target line should be drawn.
 */
const targetLineOpacity = serie => {
  let value;

  if (serie.get('target_line_position') === '1') {
    value = serie.present_value();
  } else {
    value = serie.future_value();
  }

  return value === null ? 0 : 1;
};

/**
 * Creates a unique key for a serie to be used in D3 to link the serie data to the elements rendered
 * in the SVG.
 */
const serieKey = serie => {
  return `${serie.key}-${serie.data.x}`;
};

class StackedBar extends D3Chart {
  constructor(...args) {
    super(...args);

    // this.is_empty = this.is_empty.bind(this);
    // this.draw = this.draw.bind(this);
    // this.refresh = this.refresh.bind(this);
    // this.get_columns = this.get_columns.bind(this);
    // this.display_legend = this.display_legend.bind(this);
    // this.prepare_legend_items = this.prepare_legend_items.bind(this);
    // this.prepare_data = this.prepare_data.bind(this);

    this.series = this.model.series.models;
  }

  // the stack method will filter the data and calculate the offset
  // for every item
  stackMethod(data) {
    // Group the data based on the year ("x") and then key the values by the gquery key ("id").
    //
    // Produces a Map like:
    //
    //    Map {
    //      2015 => Map { gquery_one => SerieData, gquery_two => SerieData },
    //      2050 => Map { gquery_one => SerieData, gquery_two => SerieData },
    //    }
    //
    // ... where `SerieData` is data about a series returned by `prepareData`.
    const grouped = d3.group(
      data,
      d => d.x,
      d => d.id
    );

    const keys = Array.from(new Set(data.map(d => d.id)));

    // Transform the grouped values into an array of objects, where each object describes the data
    // for each column, without extra maps and arrays around values. g[0] is the x value (year),
    // and g[1] contains the map of each gquery key and value.
    const table = Array.from(grouped.entries()).map(g => {
      // g[0] is the x value (year) and g[1] contains the map of each gquery key and [SerieData].
      const column = { x: g[0] };

      for (let serieKey of keys) {
        if (g[1].has(serieKey)) {
          column[serieKey] = g[1].get(serieKey)[0].y;
        } else {
          column[serieKey] = 0;
        }
      }

      return column;
    });

    // Stack values. This produces an array containing values for each series, in each column.
    const stacked = d3.stack().keys(keys)(table);

    // Add some useful inforamtion about the series to each value.
    const mapped = stacked.map(d => {
      d.forEach(v => (v.key = d.key));
      return d;
    });

    return mapped;
  }

  margins = {
    top: 20,
    bottom: 20,
    left: 20,
    right: 40
  };

  legendMargin = 20;

  canRenderAsTable() {
    return true;
  }

  isEmpty() {
    return d3.sum(this.prepareData(), d => d.y) <= 0;
  }

  /**
   * Looks up a series in the model by key, and returns an attribute.
   *
   * @param {string} serieKey
   *   The key identifying the serie to be queried.
   * @param {string} attribute
   *   The name of the attribute on the serie to be retrieved.
   */
  serieValue(serieKey, attribute) {
    return super.serieValue(serieKey.replace(/_future$|_present|_1990$/, ''), attribute);
  }

  draw() {
    [this.width, this.height] = this.dimensions();
    this.seriesHeight = this.height - this.legendMargin;
    this.svg = this.createSVGContainer(this.width, this.seriesHeight, this.margins);

    this.displayLegend();

    const columns = this.getColumns();

    this.x = d3
      .scaleBand()
      .padding(0.4)
      .paddingOuter(0.2)
      .rangeRound([0, this.width - this.margins.left * 2])
      .domain(columns);

    this.barWidth = this.x.bandwidth();

    // show years
    this.svg
      .selectAll('text.year')
      .data(columns)
      .enter()
      .append('svg:text')
      .attr('class', 'year')
      .text(d => d)
      .attr('x', d => this.x(d))
      .attr('dx', this.barWidth / 2)
      .attr('y', this.seriesHeight + 15)
      .attr('text-anchor', 'middle');

    this.y = d3
      .scaleLinear()
      .range([this.seriesHeight, 0])
      .domain([0, 7]);

    this.svg
      .append('g')
      .selectAll('g')
      .data(this.stackMethod(this.prepareData()), d => d.key)
      .join('g')
      .attr('class', 'serie-group')
      .attr('fill', d => this.serieValue(d.key, 'color'))
      .selectAll('rect')
      .data(d => d, serieKey)
      .join('rect')
      .attr('class', 'serie')
      .attr('x', d => this.x(d.data.x))
      .attr('y', this.seriesHeight)
      .attr('width', this.barWidth)
      .attr('height', 0)
      .attr('data-tooltip-title', d => this.serieValue(d.key, 'label'));

    $(`${this.container_selector()} rect.serie`).qtip({
      content: {
        title() {
          return $(this).attr('data-tooltip-title');
        },
        text() {
          return $(this).attr('data-tooltip-text');
        }
      },
      position: {
        target: 'mouse',
        my: 'bottom center',
        at: 'top center'
      }
    });

    // draw a nice axis
    this.yAxis = d3
      .axisRight()
      .scale(this.y)
      .ticks(5)
      .tickSize(-this.width, 10, 0)
      .tickFormat(this.formatValue);
    this.svg
      .append('svg:g')
      .attr('class', 'y_axis inner_grid')
      .attr('transform', `translate(${this.width - 25}, 0)`)
      .call(this.yAxis);

    // target lines
    // An ugly thing in the target lines is the extra attribute called "target
    // line position". If set to 1 then the target line must be shown on the
    // first column only, if 2 only on the 2nd. The CO2 chart is different, too

    return this.svg
      .selectAll('rect.target_line')
      .data(this.model.target_series(), d => d.get('gquery_key'))
      .enter()
      .append('svg:rect')
      .attr('class', 'target_line')
      .style('fill', d => d.get('color'))
      .attr('height', 2)
      .attr('width', () => this.x.bandwidth() * 1.2)
      .attr('x', s => {
        const year = s.get('target_line_position') === '1' ? this.startYear : this.endYear;
        return this.x(year) - this.x.bandwidth() * 0.1;
      })
      .attr('y', 0);
  }

  refresh(animate = true) {
    super.refresh();

    const transition = d3.transition().duration(animate ? 250 : 0);

    // calculate tallest column
    const tallest = (this.model.max_series_value() || 0) * 1.05;
    // update the scales as needed
    this.y = this.y.domain([0, tallest]).nice();

    this.yAxis.tickFormat(this.formatValue);

    // animate the y-axis
    this.svg
      .selectAll('.y_axis')
      .transition(transition)
      .call(this.yAxis.scale(this.y));

    this.svg
      .selectAll('g.serie-group')
      .data(this.stackMethod(this.prepareData()), d => d.key)
      .selectAll('rect.serie')
      .data(d => d, serieKey)
      .transition(transition)
      .attr('height', d => this.seriesHeight - this.y(d[1] - d[0]))
      .attr('y', d => this.y(d[1]))
      .attr('data-tooltip-text', d => this.formatValue(d[1]));

    // move the target lines
    this.svg
      .selectAll('rect.target_line')
      .data(
        this.model.target_series(),
        d => `${d.get('gquery_key')}-${d.get('target_line_position')}`
      )
      .style('opacity', targetLineOpacity)
      .transition(transition)
      .attr('y', d => {
        const value =
          d.get('target_line_position') === '1' ? d.safe_present_value() : d.safe_future_value();

        return this.y(value);
      });

    return this.displayLegend();
  }

  // draw grid

  getColumns() {
    const result = [this.startYear, this.endYear];
    if (this.model.year_1990_series().length) {
      result.unshift(1990);
    }
    return result;
  }

  displayLegend() {
    $(this.container_selector())
      .find('.legend')
      .remove();

    const seriesForLegend = this.prepareLegendItems();
    const legendColumns = seriesForLegend.length > 6 ? 2 : 1;

    return this.drawLegend({
      svg: this.svg,
      series: seriesForLegend,
      width: this.width,
      vertical_offset: this.seriesHeight + this.legendMargin,
      columns: legendColumns
    });
  }

  prepareLegendItems() {
    // Prepare legend
    // remove duplicate target series. Required for backwards compatibility.
    // When we'll drop the old charts we should use a single serie as target
    // rather than two.
    //
    // Also checks if series have a significant value i.e. a value larger than
    // 0.0000001 otherwise it doesn't get added to the legend.
    const targetLines = [];
    const seriesForLegend = [];

    for (let s of Array.from(this.series)) {
      const label = s.get('label');
      const total = Math.abs(s.safe_future_value()) + Math.abs(s.safe_present_value());

      if (s.get('is_target_line')) {
        if (targetLines.indexOf(label) === -1) {
          targetLines.push(label);
          seriesForLegend.push(s);
        }
        // otherwise the target line has already been added
      } else if (total > 1e-7) {
        seriesForLegend.push(s);
      }
    }

    return seriesForLegend;
  }

  // the stack layout method expects data to be in a precise format. We could
  // force the values() method but this way is simpler and cleaner.
  prepareData() {
    const series = [];

    this.model.year_1990_series().forEach(s =>
      series.push({
        x: 1990,
        y: s.safe_present_value(),
        id: s.get('gquery_key')
      })
    );

    this.model.non_target_series().forEach(s => {
      series.push({
        x: this.startYear,
        y: s.safe_present_value(),
        id: s.get('gquery_key')
      });

      series.push({
        x: this.endYear,
        y: s.safe_future_value(),
        id: s.get('gquery_key')
      });
    });

    return series;
  }
}

export default StackedBar;
