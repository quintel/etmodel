/* globals App EmptyChartMessage I18n */

import * as d3 from './d3';

import Base from './Base';
import Legend from './Legend';
import tooltips from './utils/tooltips';

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
    right: 30,
  };

  // height of the legend item
  legend_cell_height = 15;

  /**
   * Controls whether series in the legend can be clicked to hide the series in the chart.
   */
  clickableLegend = false;

  constructor(...args) {
    super(...args);

    this.startYear = App.settings.get('start_year');
    this.endYear = App.settings.get('end_year');
    this.init_margins && this.init_margins();
    this.valueFormatter = (value) => value.toString();
  }

  // Update margins to reflect font-size
  init_margins() {
    const fontSize = d3.select('body').style('font-size');
    if (!fontSize || !fontSize.match(/\d+px/)) {
      return;
    }

    const multiplier = Number.parseInt(fontSize, 10) / 13;

    if (multiplier === 1) {
      return;
    }

    for (let [key, value] of Object.entries(this.margins)) {
      this.margins[key] = value * multiplier;
    }

    // Self-destruct.
    this.init_margins = () => {};
  }

  /**
   * Looks up a series in the model by key, and returns an attribute.
   *
   * @param {string} serieKey
   *   The key identifying the serie to be queried.
   * @param {string} attribute
   *   The name of the attribute on the serie to be retrieved.
   */
  serieValue = (serieKey, attribute) => {
    const serie = this.model.series.with_gquery(serieKey);

    if (!serie) {
      throw new Error(`No series matching query: ${serieKey}`);
    }

    return serie.get(attribute);
  };

  render(force_redraw) {
    const firstRender = !this.drawn;

    if (force_redraw || firstRender) {
      this.clearContainer();
      this.containerNode().html(this.html());
      this.draw();
      this.drawn = true;
    }

    this.refresh(!firstRender);
    this.displayEmptyMessage();
    tooltips(this.containerSelector());
  }

  /**
   * Formats a value using the current valueFormatter.
   *
   * Prefer this over calling `valueFormatter` directly, as the `valueFormatter` may change
   * depending on the values shown in the chart (for example, a chart may initially be shown with
   * values in MJ and then be updated with values where GJ is more appropriate). Using the direct
   * reference to `valueFormatter` may result in a stale formatter.
   *
   * @param {number} value
   *   The value to be formatted.
   *
   * @return {string}
   */
  formatValue = (value) => this.valueFormatter(value);

  /**
   * Updates the chart with new data.
   *
   * @param {boolean} animate
   *   Sets whether to animate changes in the data from the current state to the new state.
   */
  refresh() {
    this.valueFormatter = this.createValueFormatter();
  }

  isEmpty() {
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

  d3ContainerNode() {
    return document.querySelector(this.containerSelector());
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
      this.availableHeight() - (this.margins.top + this.margins.bottom),
    ];
  }

  // Returns a D3-selected aVG container
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

  /**
   * Triggered when a legend item is clicked.
   */
  legendClick = (event, item) => {
    if (!this.clickableLegend) {
      return;
    }

    const series = this.model.series.filter((s) => s.get('label') == item.label);

    for (const serie of series) {
      serie.set('hidden', !item.active);
    }

    this.refresh();
  };

  // Builds a standard legend. Options hash:
  // - series: array of series. The label might be its 'label' attribute or its
  //           'key' attribute, which is translated with I18n.js
  // - columns: number of columns (default: 1)
  // - leftMargin: (default: 10)
  //
  drawLegend({ columns, series }) {
    let reversedSeries = [...series];
    reversedSeries.reverse();

    this._legend?.remove();

    this._legend = new Legend({
      clickable: this.clickableLegend,
      columns,
      items: reversedSeries,
      marginLeft: this.margins.left,
      onClickItem: this.legendClick,
    });

    document.querySelector(this.containerSelector()).append(this._legend.render());
  }
}
