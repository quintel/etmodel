import { interpolatePath } from 'd3-interpolate-path';

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

    const transition = d3.transition().duration(animate ? 250 : 0);

    const data = this.convertToXY(this.visibleData());

    const xScale = this.createTimeScale(this.dateSelect.currentRange());
    const yScale = this.createLinearScale();

    this.svg.select('.x_axis').call(this.createTimeAxis(xScale));
    this.svg.select('.y_axis').transition(transition).call(this.createLinearAxis(yScale));

    if (this.containerNode().find('g.serie').length > 0) {
      const lineFunction = this.line(xScale, yScale);

      this.svg
        .selectAll('g.serie')
        .data(data, (d) => d.key)
        .select('path')
        .transition(transition)
        .style('opacity', (d) => (this.serieValue(d.key, 'skip') ? 0 : 1))
        .attrTween('d', function (d) {
          const prev = this.getAttribute('d');
          const current = lineFunction(d.values);

          return interpolatePath(prev, current);
        });
    } else {
      this.drawData(data, xScale, yScale);
    }

    this.updateNegativeRegion(yScale, transition);
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
   */
  yDomain() {
    let [min, max] = d3.extent(
      this.visibleData()
        .map((serie) => d3.extent(serie.values))
        .flat()
    );

    min = Math.min(min, 0);
    max = Math.max(max, 0);

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
