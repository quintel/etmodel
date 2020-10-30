/* globals $ */

import * as d3 from 'd3';
import D3Chart from './D3Chart';
import stackData from './utils/stackData';

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
      .data(stackData(this.prepareData()), d => d.key)
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

    this.y = this.y.domain([0, (this.model.max_series_value() || 0) * 1.05]).nice();

    // Animate the y-axis
    this.svg
      .selectAll('.y_axis')
      .transition(transition)
      .call(this.yAxis.scale(this.y));

    this.svg
      .selectAll('g.serie-group')
      .data(stackData(this.prepareData()), d => d.key)
      .selectAll('rect.serie')
      .data(d => d, serieKey)
      .transition(transition)
      .attr('height', d => this.seriesHeight - this.y(d[1] - d[0]))
      .attr('y', d => this.y(d[1]))
      .attr('data-tooltip-text', d => this.formatValue(d[1]));

    // Move the target lines
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

  getColumns() {
    const years = [this.startYear, this.endYear];

    if (this.model.year_1990_series().length) {
      return [1990, ...years];
    }

    return years;
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

    for (let series of this.model.series.models) {
      const label = series.get('label');
      const total = Math.abs(series.safe_future_value()) + Math.abs(series.safe_present_value());

      if (series.get('is_target_line')) {
        if (targetLines.indexOf(label) === -1) {
          targetLines.push(label);
          seriesForLegend.push(series);
        }
        // otherwise the target line has already been added
      } else if (total > 1e-7) {
        seriesForLegend.push(series);
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
