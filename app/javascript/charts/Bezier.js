/* globals $ _ */

import * as d3 from 'd3';
import D3Chart from './D3Chart';
import stackData from './utils/stackData';

/**
 * Stacks the data provided.
 *
 * Expects an object containing `keys` which has a list of the keys, corresponding with series which
 * are to be shown in the chart, and `data` containing the data for each year.
 *
 * `data` should be in the form: { x: number, [serieKey: string]: number }
 *
 * @todo Can this be made into a method?
 *   this.stackSeries = d3
 *     .stack()
 *     .keys(this.model.non_target_series.map(serie => serie.get('gquery')))
 */
const stackSeries = ({ keys, data }) => {
  return d3.stack().keys(keys)(data);
};

class Bezier extends D3Chart {
  tableOptions = {
    sorter() {
      return series => series.reverse();
    }
  };

  legend_margin = 20;

  margins = {
    top: 20,
    bottom: 20,
    left: 20,
    right: 30
  };

  canRenderAsTable() {
    return true;
  }

  /**
   * Performs the initial draw of the chart. Creates series, axis, tooltips, etc, with real data
   * being added in the call to refresh.
   *
   * The chart is a stacked area chart. D3 provides some utility methods that calculate the offset
   * for stacked data. It expects data to be given in a specific format and then it will add the
   * calculated attributes in place, ie it will add new attributes (such as y0) to the array/hash
   * we're passing as parameter.
   *
   * Once we have the stacked data, grouped by serie key, we can pass the values to the SVG area
   * method, which creates the SVG attributes required to draw the paths (and add some nice
   * interpolations between the start and end years.).
   */
  draw() {
    [this.width, this.height] = this.dimensions();

    // dimensions of the chart body
    this.seriesHeight = this.height - this.legend_margin;
    this.seriesWidth = this.width - 15;

    this.svg = this.createSVGContainer(this.width, this.seriesHeight, this.margins);

    this.displayLegend();

    // This method groups the series by key, creating an array of objects
    // this.nest = d3.nest().key(d => d.id);

    // Run the stack method on the nested entries
    const stacked_data = stackData(this.prepareData());

    this.x = d3
      .scaleLinear()
      .range([0, this.seriesWidth])
      .domain([this.startYear, this.endYear]);

    // show years at the corners
    this.svg
      .selectAll('text.year')
      .data([this.startYear, this.endYear])
      .enter()
      .append('svg:text')
      .attr('class', 'year')
      .attr('text-anchor', (d, i) => (i === 0 ? 'start' : 'end'))
      .text(d => d)
      .attr('x', (d, i) => (i === 0 ? 0 : this.seriesWidth))
      .attr('y', this.seriesHeight + 16);

    this.y = d3
      .scaleLinear()
      .range([this.seriesHeight, 0])
      .domain([0, 1]);

    // This method will return the SVG area attributes. The values it receives
    // should be already stacked
    this.area = d3
      .area()
      .curve(d3.curveBasis)
      .x(d => this.x(d.data.x))
      .y0(d => this.y(d[0]))
      .y1(d => this.y(d[1]));

    // draw a nice axis
    this.y_axis = d3
      .axisRight()
      .scale(this.y)
      .ticks(4)
      .tickSize(-this.seriesWidth, 6);

    // there we go
    this.svg
      .selectAll('path.serie')
      .data(stacked_data, s => s.key)
      .enter()
      .append('svg:path')
      .attr('class', 'serie')
      .attr('d', d => this.area(d))
      .style('fill', d => this.serieValue(d.key, 'color'))
      .style('opacity', 0.8)
      .attr('data-tooltip-title', d => this.serieValue(d.key, 'label'));

    this.svg
      .append('svg:g')
      .attr('class', 'y_axis inner_grid')
      .attr('transform', `translate(${this.seriesWidth}, 0)`)
      .call(this.y_axis);
  }

  refresh() {
    super.refresh();

    // calculate tallest column
    const tallest = Math.max(_.sum(this.model.values_present()), _.sum(this.model.values_future()));

    // update the scales
    this.y.domain([0, tallest]);

    // animate the y-axis
    this.y_axis.tickFormat(this.formatValue);

    this.svg
      .selectAll('.y_axis')
      .transition()
      .call(this.y_axis.scale(this.y));

    // Make the tick line corresponding with value 0 darker.
    this.svg.selectAll('.y_axis .tick').attr('class', d => (d === 0 ? 'tick bold' : 'tick'));

    // See above for explanation of this method chain
    const stacked_data = stackData(this.prepareData());

    this.displayLegend();

    return this.svg
      .selectAll('path.serie')
      .data(stacked_data, d => d.key)
      .attr('data-tooltip-text', d => {
        const present = Math.abs(d[0][1]) - Math.abs(d[0][0]);
        const future = Math.abs(d[1][1]) - Math.abs(d[1][0]);

        return `${this.startYear}: ${this.formatValue(present)}</br> \
          ${this.endYear}: ${this.formatValue(future)}`;
      })
      .transition()
      .attr('d', d => this.area(d));
  }

  displayLegend() {
    $(this.containerSelector())
      .find('.legend')
      .remove();

    const series = _.filter(
      this.model.series.models,
      s => Math.abs(s.safe_future_value()) + Math.abs(s.safe_present_value()) > 1e-7
    );

    return this.drawLegend({
      svg: this.svg,
      series,
      width: this.width,
      vertical_offset: this.seriesHeight + this.legend_margin,
      columns: 2
    });
  }

  // We need to pass the chart series through the stacking function and the SVG area function. To do
  // this let's format the data as an array. An interpolated mid-point is added to generate a
  // S-curve.
  prepareData() {
    let leftStack = 0;
    let midStack = 0;
    let rightStack = 0;

    const values = [];

    // The mid point should be between the left and side value, which are stacked.
    this.model.non_target_series().forEach(s => {
      // Calculate the mid point boundaries
      const minValue = Math.min(leftStack + s.present_value(), rightStack + s.future_value());
      const maxValue = Math.max(leftStack + s.present_value(), rightStack + s.future_value());

      let midPoint =
        s.safe_future_value() > s.safe_present_value()
          ? s.safe_present_value()
          : s.safe_future_value();

      midPoint += midStack;

      // This ensures that if the chart shows an overall increasing trend that we do not plot a
      // value which appears to show a decrease in the midYear, and vice-versa.
      midPoint = midPoint < minValue ? minValue : midPoint > maxValue ? maxValue : midPoint;

      // The stacking function wants the non-stacked values
      midPoint -= midStack;

      midStack += midPoint;
      leftStack += s.safe_present_value();
      rightStack += s.safe_future_value();

      const id = s.get('gquery_key');
      const midYear = (this.startYear + this.endYear) / 2;

      values.push({ id, x: this.startYear, y: s.safe_present_value() });
      values.push({ id, x: midYear, y: midPoint });
      values.push({ id, x: this.endYear, y: s.safe_future_value() });
    });

    return values;
  }
}

export default Bezier;
