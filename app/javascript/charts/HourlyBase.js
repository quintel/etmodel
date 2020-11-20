/* globals $ _ D3ChartDateSelect I18n MeritTransformator */

import * as d3 from 'd3';
import D3Chart from './D3Chart';

/**
 * Receives a serie and creates an object with the data needed to show the data in the chart.
 *
 * If the query does not have a value, the values are initialised to an array of 8760 zeros.
 */
const serieToData = serie => {
  let values = serie.future_value();

  if (!values || !values.length) {
    // Series with no values are treated as all-zeros.
    values = Array.apply(null, Array(8760)).map(() => 0);
  }

  return {
    color: serie.get('color'),
    label: serie.get('label'),
    key: serie.get('gquery').get('key'),
    skip: serie.get('skip'),
    is_target: serie.get('is_target_line'),
    values
  };
};

/**
 * Converts an array of SeriesData values into an array of "tables"; one element per time point.
 */
const toTable = series => {
  const length = series[0].values.length;
  const data = [];

  for (let i = 0; i < length; i++) {
    const hourData = { x: series[0].values[i].x };

    for (let serieData of series) {
      hourData[serieData.key] = serieData.values[i].y;
    }

    data.push(hourData);
  }

  return data;
};

/**
 * A generic base for charts which show hourly curves.
 */
class HourlyBase extends D3Chart {
  margins = {
    top: 20,
    bottom: 20,
    left: 65,
    right: 2,
    labelLeft: 30
  };

  /**
   * When downsampling data (for example, to fit an entire year of data into a chart) this
   * determines how we sample the value for each day: the "mean" of values of values within the
   * day, or the "max" value within the 24-hour period.
   */
  downsampleWith = 'mean';

  // constructor(...args) {
  //   this.convertToXY = this.convertToXY.bind(this);
  //   super(...args);
  // }

  /**
   * Performs the initial draw of the chart and axes. Data is not drawn.
   */
  draw() {
    this.series = [...this.model.non_target_series(), ...this.model.target_series()];

    [this.width, this.height] = this.dimensions();

    this.svg = this.createSVGContainer(this.width, this.height, this.margins);

    this.dateSelect = new D3ChartDateSelect(this.containerSelector(), 8760, this.downsampleWith);
    this.dateSelect.draw(this.refresh.bind(this));

    this.xScale = this.drawXAxis();
    this.yScale = this.drawYAxis();
  }

  /**
   * Draws or updates data.
   */
  refresh() {
    this._visibleData = null;
    super.refresh();
  }

  /**
   * Creates the formatter for values, using the largest hourly value.
   */
  createValueFormatter(opts = {}) {
    return this.createScaler(this.maxYValue() / 100, this.model.get('unit'), opts);
  }

  stackOffset() {
    return d3.stackOffsetNone;
  }

  setStackedData() {
    this.chartData = this.convertData();

    const stackedData = this.getStackedData(
      d3
        .stack()
        .offset(this.stackOffset())
        .keys(this.model.non_target_series().map(s => s.get('gquery_key')))
    );

    this.stackedData = stackedData.stacked;
    this.totalDemand = stackedData.total;
  }

  getStackedData(stack) {
    const lastId = this.chartData.length - 1;

    return {
      stacked: stack(toTable(this.chartData.slice(0, lastId))),
      total: [this.chartData[lastId]]
    };
  }

  drawLegend(series, columns = 2) {
    $(this.container_selector())
      .find('div.legend')
      .remove();

    return super.drawLegend({
      series,
      width: this.width,
      columns
    });
  }

  /**
   * Draws the X axis onto the charts, configuring the scaling and grey grid
   */
  drawXAxis() {
    const scale = this.createTimeScale([new Date(1970, 0, 0), new Date(1970, 11, 30)]);
    const axis = this.createTimeAxis(scale);

    this.svg
      .append('g')
      .attr('class', 'x_axis inner_grid')
      .attr('transform', `translate(0, ${this.height})`)
      .call(axis);

    return scale;
  }

  /**
   * Draws the Y axis onto the charts, configuring the scaling and grey grid
   */
  drawYAxis() {
    const scale = this.createLinearScale();
    const axis = this.createLinearAxis(scale);

    this.svg
      .append('g')
      .attr('class', 'y_axis inner_grid')
      .call(axis)
      .append('text')
      .attr('transform', 'rotate(-90)')
      .attr('class', 'unit')
      .attr('y', (this.margins.left / 2) * -1 - this.margins.labelLeft)
      .attr('x', (this.height / 2) * -1 + 12)
      .attr('dy', '.71em')
      .attr('font-weight', 'bold')
      .style('text-anchor', 'end');

    return scale;
  }

  filterYValue(serie, value) {
    return value;
  }

  maxYValue() {
    const targetKeys = this.model.target_series().map(s => s.get('gquery_key'));
    const grouped = _.groupBy(this.visibleData(), d => _.contains(targetKeys, d.key));

    const targets = _.pluck(grouped[true], 'values');
    const series = _.pluck(grouped[false], 'values');

    // Negatives, typically caused by storage charting, cause incorrect calculation of the max value
    // and result in incorrect vertical scaling.
    const nonNegative = val => (val < 0 ? 0 : val);

    let max = 0.0;

    for (var index = 0; index < series[0].length; index++) {
      const aggregateLoad = d3.sum(series, s => nonNegative(s[index]));
      const targetLoad = d3.max(targets, s => nonNegative(s[index]));

      if (aggregateLoad > max) {
        max = aggregateLoad;
      }

      if (targetLoad > max) {
        max = targetLoad;
      }
    }

    return max;
  }

  createLinearScale() {
    return d3
      .scaleLinear()
      .domain([0, this.maxYValue() * 1.05])
      .range([this.height, 0])
      .nice();
  }

  createLinearAxis(scale) {
    return d3
      .axisLeft()
      .scale(scale)
      .ticks(7)
      .tickSize(-this.width, 0)
      .tickFormat(v => this.formatValue(v).split(' ')[0]);
  }

  createTimeScale(domain) {
    return d3
      .scaleUtc()
      .range([0, this.width])
      .domain(domain);
  }

  createTimeAxis(scale) {
    const formatStr = this.dateSelect.isWeekly() ? '%-d %b' : '%b';
    const formatter = val => I18n.strftime(val, formatStr);

    return d3
      .axisBottom()
      .scale(scale)
      .tickValues(this.dateSelect.tickValues())
      .tickFormat(formatter);
  }

  visibleData() {
    if (this._visibleData) {
      return this._visibleData;
    }

    const rawData = this.series.map(serieToData);

    this._visibleData = rawData
      .filter(serie => serie.values.length)
      .map(serie => {
        return $.extend({}, serie, {
          values: MeritTransformator.transform(
            serie.values,
            this.dateSelect.val(),
            this.downsampleWith
          )
        });
      });

    return this._visibleData;
  }

  convertData = () => this.convertToXY(this.visibleData());

  convertToXY(data) {
    const dateVal = this.dateSelect.val();
    const seconds = dateVal < 1 ? 86400000 : 3600000;
    const offset = dateVal < 1 ? 0 : 168 * (dateVal - 1);

    return data.map(chart => ({
      ...chart,
      values: chart.values.map((value, hour) => ({
        x: new Date((hour + offset) * seconds),
        y: this.filterYValue(chart, value)
      }))
    }));
  }
}

export default HourlyBase;
