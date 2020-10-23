/* globals App EmptyChartMessage I18n */

import * as d3 from 'd3';
import Base from './Base';

// This is mostly an abstract class
//
// The derived classes should implement the draw() method for the initial
// rendering and the refresh() for the later updates.
// They should also call @initialize_defaults() in their initialize method

/**
 * This base class contains function useful to rendering a D3 chart.
 *
 * TODO This should not inherit from Base. Rather Base should represent a wrappepr view, which sets
 * up the chart or table, renders the header, with this class being specific to the chart itself.
 */
export default class extends Base {
  // Default values, derived class might have different values
  margins = {
    top: 20,
    bottom: 20,
    left: 20,
    right: 30
  };

  // height of the legend item
  legend_cell_height = 15;

  constructor(...args) {
    super(...args);

    this.startYear = App.settings.get('start_year');
    this.endYear = App.settings.get('end_year');
    this.init_margins && this.init_margins();
  }

  // Update margins to reflect font-size
  init_margins() {
    const fontSize = d3.select('body').style('font-size');
    if (!fontSize || !fontSize.match(/\d+px/)) {
      return;
    }

    const multiplier = parseInt(fontSize, 10) / 13;
    if (multiplier === 1) {
      return;
    }

    this.margins = Object.keys(this.margins).reduce((memo, key) => {
      memo[key] = Math.ceil(this.margins[key] * multiplier);
    }, {});

    // Self-destruct.
    this.init_margins = () => {};
  }

  render(force_redraw) {
    if (force_redraw || !this.drawn) {
      this.clearContainer();
      this.containerNode().html(this.html());
      this.formatValue = value => value;
      this.draw();
      this.drawn = true;
    }

    this.refresh();
    this.displayEmptyMessage();
  }

  refresh() {
    this.formatValue = this.createValueFormatter();
  }

  is_empty() {
    return false;
  }

  displayEmptyMessage() {
    EmptyChartMessage.display(this);
  }

  html() {
    let type = this.model.get('type');

    if (type === 'd3') {
      type = this.model.get('key');
    }

    return `<div id='${this.chartContainerId()}' class='d3_container ${type}'></div>`;
  }

  chartContainerId() {
    return `d3_${this.model.get('key')}_${this.model.get('container')}`;
  }

  containerSelector() {
    return `#${this.chartContainerId()}`;
  }

  canRenderAsTable() {
    return false;
  }

  canvas() {
    return this.$el.find('.chart_canvas');
  }

  availableWidth() {
    return this.canvas().width();
  }

  availableHeight() {
    return this.canvas().height();
  }

  // Returns a [width, height] array
  dimensions() {
    return [
      this.availableWidth() - (this.margins.left + this.margins.right),
      this.availableHeight() - (this.margins.top + this.margins.bottom)
    ];
  }

  // Returns a D3-selected SVG container
  //
  createSVGContainer(width, height, margins, className) {
    return d3
      .select(this.containerSelector())
      .append('svg:svg')
      .attr('height', height + margins.top + margins.bottom)
      .attr('width', width + margins.left + margins.right)
      .attr('class', className || '')
      .append('svg:g')
      .attr('transform', `translate(${margins.left}, ${margins.top})`);
  }

  legendClick(d) {
    return d;
  }

  // Builds a standard legend. Options hash:
  // - series: array of series. The label might be its 'label' attribute or its
  //           'key' attribute, which is translated with I18n.js
  // - columns: number of columns (default: 1)
  // - leftMargin: (default: 10)
  //
  drawLegend(opts) {
    opts = Object.assign({ columns: 1, leftMargin: 10 }, opts);

    opts.columns = opts.columns || 1;
    opts.leftMargin = opts.leftMargin || 10;
    const legendItemWidth = (opts.width - opts.leftMargin) / opts.columns;

    const series = opts.series.reverse().chunk(opts.columns);

    d3.select(this.containerSelector())
      .append('div')
      .attr('class', 'legend')
      .style('margin-left', `${opts.leftMargin + this.margins.left}px`)
      .selectAll('.legend-column')
      .data(series)
      .enter()
      .append('div')
      .attr('class', 'legend-column')
      .style('width', `${legendItemWidth}px`);

    d3.selectAll('.legend-column').each(function(items) {
      const scope = d3
        .select(this)
        .selectAll('.legend-item')
        .data(items)
        .enter()
        .append('div')
        .attr('class', 'legend-item')
        .classed('hidden', d => d.get('skip'))
        .classed('target_line', d => d.get('is_target_line'))
        .on('click', d => this.legendClick(d));

      scope
        .append('span')
        .attr('class', 'rect')
        .style('background-color', d => d.get('color'));

      scope
        .append('span')
        .text(d => d.get('label') || I18n.t(`output_element_series.labels.${d.get('key')}`));
    });
  }
}
