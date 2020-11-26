/* globals App I18n */

import * as d3 from './d3';
import D3Chart from './D3Chart';
import { groupedStack } from './utils/stackData';
import negativeRegionRect from './utils/negativeRegionRect';

const stack = d3.stack().offset(d3.stackOffsetDiverging);

/**
 * Slices data about a year to 12 individual months.
 */
const sliceToMonth = (data) => {
  const cumulativeDaysPerMonth = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  const dayLength = data.length / 365;

  return cumulativeDaysPerMonth.map((startDay, index) => {
    let endDay = cumulativeDaysPerMonth[index + 1] || 365;
    return data.slice(startDay * dayLength, endDay * dayLength);
  });
};

/**
 * Given the series for the chart, extracts the unique list of groups used.
 */
const groupKeys = (series) => [...new Set(series.map((s) => s.get('group')))];

/**
 * The hourly summarized chart receives curves describing load for each hour in the year (8760 data
 * points per series). It presents this data summarised as a bar chart - one per month in the year.
 *
 * The chart needs a number of scales in order to work:
 *
 * * y          - A standard Y scale, from lowest (possibly negative) stacked value to the highest.
 * * groupScale - The main X axis, splits the chart into different time periods (for example, all
 *                months within a year, or all weeks within a month).
 * * stackScale - When multiple bars are present for each time period (e.g., supply and demand bars
 *                for each month), groupX defines each column.
 */
class HourlySummarized extends D3Chart {
  legendMargin = 20;
  tickCount = 5;

  margins = {
    top: 20,
    right: 0,
    bottom: 20,
    left: 50,
  };

  /**
   * Event triggered whenever the group which wraps the data for a group (a month).
   */
  onMonthSelect = ({ currentTarget }) => {
    const linkedChart = this.model.get('config').linked_chart;

    if (!linkedChart) {
      return false;
    }

    const monthNum = Number.parseInt(currentTarget.dataset.month, 10);

    if (Number.isNaN(monthNum)) {
      return false;
    }

    App.settings.set('merit_charts_date', `month,${monthNum + 1}`);

    if (!App.charts.chart_already_on_screen(linkedChart)) {
      App.charts.load(linkedChart);
    }
  };

  draw() {
    [this.width, this.height] = this.dimensions();

    const groupNames = groupKeys(this.model.non_target_series());

    this.stackLabelHeight = groupNames.length > 1 ? 60 : 0;
    this.height += this.stackLabelHeight;
    this.seriesHeight = this.height - this.legendMargin - this.stackLabelHeight;

    this.svg = this.createSVGContainer(
      this.width,
      this.seriesHeight + this.stackLabelHeight,
      this.margins
    );

    this.groupScale = d3
      .scaleBand()
      .padding(0)
      .rangeRound([0, this.width])
      .domain([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);

    this.stackScale = d3
      .scaleBand()
      .padding(0.05)
      .paddingOuter(0.1)
      .rangeRound([0, this.groupScale.bandwidth()])
      .domain(groupNames);

    this.yScale = d3.scaleLinear().range([this.seriesHeight, 0]).domain([0, 1]);

    // Add a "negative region" which shades area of the chart representing values below zero.
    const [negativeRect, updateNegativeRect] = negativeRegionRect(this.width, this.yScale);

    this.updateNegativeRegion = updateNegativeRect;
    this.svg.node().append(negativeRect);

    // The stacked data consists of an array containing the data for each group, inside of which is
    // an array containing data for each series:
    //
    // [
    //   [
    //     [[0, 10],  [0, 10],  key: "electricity"],
    //     [[10, 15], [10, 16], key: "heat"],
    //   ]
    // ]
    //
    // Join the entire dataset, drawing a <g> for for each group. The group is positioned using the
    // groupScale.
    const groups = this.svg
      .append('g')
      .selectAll('g')
      .data(groupedStack(this.prepareData(), stack), (d, i) => `month-${i}`)
      .join('g')
      .attr('class', `date-group ${this.model.get('config').linked_chart ? 'linked' : ''}`)
      .attr('transform', (d, i) => {
        return `translate(${this.groupScale(i)},0)`;
      })
      .attr('data-month', (d, i) => i)
      .on('click', this.onMonthSelect);

    // Add a transparent rect to each group, used to capture click events which may trigger actions
    // in other charts.
    groups
      .append('rect')
      .attr('class', 'date-group-bg')
      .attr('x', 0)
      .attr('y', -3)
      .attr('height', this.seriesHeight + 3)
      .attr('width', this.groupScale.bandwidth());

    // Join each series so that all "electricity" data within a group is drawn together inside
    // another <g>
    const series = groups
      .selectAll('g.group')
      .data(
        (d) => d,
        (d) => `${d.key}-${d.index}`
      )
      .join('g')
      .attr('class', 'serie-group')
      .attr('fill', (d) => {
        return this.serieValue(d.key, 'color');
      });

    // Finally join each datapoint for a series (the seriesKey, typically present and future years).
    series
      .selectAll('rect.serie')
      .data(
        (d) => d,
        (d, i) => `${d.key}-${i}`
      )
      .join('rect')
      .attr('class', 'serie')
      .attr('x', (d) => this.stackScale(d.data.x))
      .attr('y', this.seriesHeight)
      .attr('width', this.stackScale.bandwidth())
      .attr('height', 0)
      .attr('y', (d) => this.yScale(d[1]))
      .attr('height', (d) => this.yScale(d[0]) - this.yScale(d[1]))
      .attr('data-tooltip-title', (d) => this.serieValue(d.key, 'label'));

    // An axis which shows each group ("Jan", "Feb", etc).
    this.groupAxis = d3
      .axisBottom()
      .scale(this.groupScale)
      .ticks(this.groupScale.domain().length)
      .tickFormat((d) => I18n.t('date.abbr_month_names')[d + 1]);

    this.svg
      .append('g')
      .attr('class', 'x_axis group-axis')
      .attr('transform', `translate(0, ${this.seriesHeight + this.stackLabelHeight})`)
      .call(this.groupAxis);

    // Add an axis for each stack.

    if (groupNames.length > 1) {
      this.stackAxis = d3
        .axisBottom()
        .scale(this.stackScale)
        .tickSize(0)
        .ticks(this.groupScale.domain().length)
        .tickFormat((d) => I18n.t(`output_element_series.groups.${d}`));

      this.svg
        .append('g')
        .selectAll('g')
        .data(groupedStack(this.prepareData(), stack)) /* TODO: Add key. */
        .join('g')
        .attr('class', 'x_axis stack-axis')
        .attr('transform', (d, i) => {
          return `translate(${
            this.groupScale(i) - this.stackScale.bandwidth() * this.stackScale.paddingOuter() * 3
          }, ${this.seriesHeight})`;
        })
        .call(this.stackAxis)
        .selectAll('text')
        .style('text-anchor', 'end')
        .attr('dx', '-6px')
        .attr('transform', 'rotate(-90)');
    }

    // Draw the Y axis.
    this.yAxis = d3
      .axisLeft()
      .scale(this.yScale)
      .ticks(this.tickCount)
      .tickSize(-this.width, 10, 0)
      .tickFormat(this.formatValue);

    this.svg.append('svg:g').attr('class', 'y_axis inner_grid').call(this.yAxis);

    // Make the tick line corresponding with value 0 darker.
    this.svg.selectAll('.y_axis .tick').attr('class', (d) => (d === 0 ? 'tick bold' : 'tick'));

    this.drawLegend({
      series: this.legendSeries(),
      columns: 2,
    });
  }

  refresh(animate = true) {
    super.refresh();

    const transition = d3.transition().duration(animate ? 250 : 0);
    const data = groupedStack(this.prepareData());

    // Min value.
    let min = 0;
    let max = 0;

    data.forEach((groupedData) => {
      groupedData.forEach((serieData) => {
        serieData.forEach(([lower, upper]) => {
          if (upper < lower && upper - lower < min) {
            min = upper - lower;
          } else if (lower < min) {
            min = lower;
          }

          if (upper > max) {
            max = upper;
          }
        });
      });
    });

    this.yScale.domain([min, max]);

    this.svg
      .selectAll('.y_axis')
      .transition(transition)
      .call(this.yAxis.scale(this.yScale.nice(this.tickCount)));

    const groups = this.svg.selectAll('g.date-group').data(data, (d, i) => `month-${i}`);

    // Join each series so that all "electricity" data within a group is drawn together inside
    // another <g>
    const series = groups.selectAll('g.serie-group').data(
      (d) => d,
      (d) => `${d.key}-${d.index}`
    );

    // Finally join each datapoint for a series (the seriesKey, typically present and future years).
    series
      .selectAll('rect')
      .data(
        (d) => d,
        (d, i) => `${d.key}-${i}`
      )
      .attr('y', (d) => (d[0] > d[1] ? this.yScale(d[0]) : this.yScale(d[1])))
      .attr('height', (d) => Math.abs(this.yScale(d[0]) - this.yScale(d[1])))
      .attr('data-tooltip-text', (d) => this.formatValue(Math.abs(d[1]) - Math.abs(d[0])));

    this.updateNegativeRegion(this.yScale, transition);
  }

  prepareData() {
    const values = [];

    this.model.non_target_series().forEach((serie) => {
      const base = {
        id: serie.get('id'),
        stackKey: serie.get('group'),
        x: serie.get('group'),
      };

      values.push(
        ...sliceToMonth(serie.safe_future_value()).map((monthVals, groupKey) =>
          Object.assign({}, base, { groupKey, y: d3.sum(monthVals) })
        )
      );
    });

    return values;
  }

  /**
   * Creates a function which will format values for the main axis of the chart. The default from
   * Base is overriden as we need to be stack-aware when calculating the max value for this chart.
   */
  createValueFormatter() {
    let maxValue = 0;

    groupedStack(this.prepareData()).forEach((monthData) => {
      monthData.forEach((datum) => {
        maxValue = Math.max(maxValue, ...datum.map(([, upper]) => upper));
      });
    });

    return this.createScaler(maxValue, this.model.get('unit'), {});
  }

  legendSeries() {
    const byLabel = new Map();

    for (const serie of this.model.series.models) {
      byLabel.set(serie.get('label'), serie);
    }

    // eslint-disable-next-line unicorn/prefer-spread
    return Array.from(byLabel.values());
  }
}

export default HourlySummarized;
