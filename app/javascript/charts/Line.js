/* globals _ */

import * as d3 from './d3';
import HourlyBase from './HourlyBase';
import negativeRegionRect from './utils/negativeRegionRect';

/**
 * An hourly chart which draws each series as a line. Supports negative values, with the negative
 * region being shaded in light gray.
 */
class Line extends HourlyBase {
  margins = {
    top: 20,
    right: 20,
    bottom: 20,
    left: 75,
    labelLeft: 20,
  };

  downsampleWith = 'max';

  draw() {
    super.draw();
    this.drawLegend(this.model.non_target_series(), 2);
  }

  refresh(animate = true) {
    super.refresh(animate);

    const data = this.convertToXY(this.visibleData());

    const xScale = this.createTimeScale(this.dateSelect.currentRange());
    const yScale = this.createLinearScale();

    this.svg.select('.x_axis').call(this.createTimeAxis(xScale));
    this.svg.select('.y_axis').call(this.createLinearAxis(yScale));

    if (this.containerNode().find('g.serie').length > 0) {
      const lineFunction = this.line(xScale, yScale);

      this.svg
        .selectAll('g.serie')
        .data(data, (d) => d.key)
        .select('path')
        .attr('d', (d) => lineFunction(d.values));
    } else {
      this.drawData(data, xScale, yScale);
    }

    this.updateNegativeRegion(yScale);
  }

  drawData(data, xScale, yScale) {
    const lineFunction = this.line(xScale, yScale);

    this.svg
      .selectAll('path.serie')
      .data(data, (d) => d.key)
      .enter()
      .append('g')
      .attr('class', 'serie')
      .append('path')
      .attr('d', (d) => lineFunction(d.values))
      .attr('stroke', (d) => d.color)
      .attr('class', (d) => d.key)
      .attr('stroke-width', 2)
      .attr('fill', 'none');

    const [rect, updateRect] = negativeRegionRect(this.width, yScale);

    this.updateNegativeRegion = updateRect;
    this.svg.node().append(rect);
  }

  line(xScale, yScale) {
    return d3
      .line()
      .x((d) => xScale(d.x))
      .y((d) => yScale(d.y))
      .curve(d3.curveMonotoneX);
  }

  /**
   * Computes the minimum and maximum values to be used for the Y axis.
   *
   * When all values are positive, the domain will be from zero to the largest value. When there are
   * both positive and negative values, the domain will be from the negative absolute largest to the
   * positive absolute largest (i.e. if the min is -10 and the max is 5, the domain will be -10 to
   * 10).
   */
  yDomain() {
    let [min, max] = d3.extent(
      _.flatten(this.visibleData().map((serie) => d3.extent(serie.values)))
    );

    min = Math.min(min, 0);
    max = Math.max(max, 0);

    if (min < 0 && max > 0) {
      return Math.abs(min) > max ? [min, -min] : [-max, max];
    }

    return [min, max];
  }

  maxYValue() {
    return Math.max(...this.yDomain().map((v) => Math.abs(v)));
  }

  createLinearScale() {
    return d3.scaleLinear().domain(this.yDomain()).range([this.height, 0]).nice(7);
  }
}

export default Line;
