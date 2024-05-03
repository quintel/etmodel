/* globals $ _ I18n */

import * as d3 from '../d3';
import D3Chart from '../D3Chart';

import DateSelect from './DateSelect';
import sampleCurves from './sampleCurves';
import { zeroInvisibleSerie } from '../utils/zeroInvisibles';

// Used to filter values in maxYValue.
//
// Negatives, typically caused by storage charting, cause incorrect calculation of the max value
// and result in incorrect vertical scaling.
const nonNegative = (val) => (val < 0 ? 0 : val);

/**
 * Receives a serie and creates an object with the data needed to show the data in the chart.
 *
 * If the query does not have a value, the values are initialised to an array of 8760 zeros.
 */
const serieToData = (serie) => {
  let values = serie.future_value();

  if (!values || values.length === 0) {
    // Series with no values are treated as all-zeros.
    values = Array.apply(undefined, new Array(8760)).map(() => 0);
  }

  return {
    color: serie.get('color'),
    label: serie.get('label'),
    key: serie.get('gquery').get('key'),
    hidden: serie.get('hidden'),
    is_target: serie.get('is_target_line'),
    values,
  };
};

/**
 * Converts an array of SeriesData values into an array of "tables"; one element per time point.
 */
const toTable = (series) => {
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
    left: 85,
    right: 0,
    labelLeft: 30,
  };

  /**
   * When downsampling data (for example, to fit an entire year of data into a chart) this
   * determines how we sample the value for each day: the "mean" of values of values within the
   * day, or the "max" value within the 24-hour period.
   */
  downsampleWith = 'mean';

  /**
   * Items in the legend may be clicked to hide the series.
   */
  clickableLegend = true;

  /**
   * Performs the initial draw of the chart and axes. Data is not drawn.
   */
  draw() {
    this.series = [...this.model.non_target_series(), ...this.model.target_series()];

    [this.width, this.height] = this.dimensions();

    this.svg = this.createSVGContainer(this.width, this.height, this.margins);

    this.dateSelect = new DateSelect(
      this.d3ContainerNode(),
      this.model.get('config')?.downsample_with || this.downsampleWith
    );

    this.dateSelect.draw(this.refresh.bind(this));

    this.model.once('remove', this.dateSelect.remove);

    this.xScale = this.drawXAxis();
    this.yScale = this.drawYAxis();
  }

  /**
   * Draws or updates data.
   */
  refresh() {
    this._visibleData = undefined;
    super.refresh();
  }

  /**
   * Creates the formatter for values, using the largest hourly value.
   */
  createValueFormatter(opts = {}) {
    const [min, max] = this.extent();
    const absMax = Math.max(Math.abs(min), Math.abs(max));

    return this.createScaler(absMax, this.model.get('unit'), opts);
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
        .keys(this.model.non_target_series().map((s) => s.get('gquery_key')))
    );

    this.stackedData = stackedData.stacked;
    this.totalDemand = stackedData.total;
  }

  getStackedData(stack) {
    const lastId = this.chartData.length - 1;

    return {
      stacked: stack(toTable(this.chartData.slice(0, lastId))),
      total: [this.chartData[lastId]],
    };
  }

  drawLegend(series, columns = 1) {
    return super.drawLegend({ columns, series });
  }

  /**
   * Draws the X axis onto the charts, configuring the scaling and grey grid
   */
  drawXAxis() {
    const scale = this.createTimeScale(this.dateSelect.currentRange());
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

    this.svg.append('g').attr('class', 'y_axis inner_grid').call(axis);

    return scale;
  }

  filterSeriesValues(values) {
    return values;
  }

  maxYValue() {
    const [, max] = this.extent();
    return max;
  }

  extent() {
    const targetKeys = this.model.target_series().map((s) => s.get('gquery_key'));
    const grouped = _.groupBy(this.visibleData(), (d) => _.contains(targetKeys, d.key));

    const targets = _.pluck(grouped[true], 'values');
    const series = _.pluck(grouped[false], 'values');

    let max = 0;

    for (var index = 0; index < series[0].length; index++) {
      const aggregateLoad = d3.sum(series, (s) => nonNegative(s[index]));
      const targetLoad = d3.max(targets, (s) => nonNegative(s[index]));

      if (aggregateLoad > max) {
        max = aggregateLoad;
      }

      if (targetLoad > max) {
        max = targetLoad;
      }
    }

    return [0, max];
  }

  tickCount() {
    return Math.floor((this.height - this.margins.top - this.margins.bottom) / 30);
  }

  createLinearScale() {
    return d3.scaleLinear().domain(this.extent()).range([this.height, 0]).nice(this.tickCount());
  }

  createLinearAxis(scale) {
    const axis = d3
      .axisLeft()
      .scale(scale)
      .ticks(this.tickCount())
      .tickSize(-this.width, 0)
      .tickFormat((v) => this.formatValue(v));

    if (scale.domain()[0] === 0 && scale.domain()[1] === 0) {
      axis.scale(scale.domain([0, 1])).tickFormat((v) => {
        return v === 0 ? this.formatValue(v) : '';
      });
    }

    return axis;
  }

  createTimeScale(domain) {
    return d3.scaleUtc().range([0, this.width]).domain(domain);
  }

  createTimeAxis(scale) {
    const formatStr = this.dateSelect.isAll() ? '%b' : '%-d %b';
    const formatter = (val) => I18n.strftime(val, formatStr);

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

    const rawData = this.series.map((s) => serieToData(s));

    this._visibleData = rawData
      .filter((serie) => serie.values.length)
      .map((serie) => {
        return zeroInvisibleSerie(
          $.extend({}, serie, {
            values: sampleCurves(serie.values, this.dateSelect.toTransformOptions()),
          })
        );
      });

    return this._visibleData;
  }

  convertData = () => this.convertToXY(this.visibleData());

  convertToXY(data) {
    const seconds = this.dateSelect.secondsPerSample() * 1000;
    const offset = this.dateSelect.startDate();

    return data.map((chart) => ({
      ...chart,
      values: this.filterSeriesValues(chart.values, chart).map((value, i) => ({
        x: new Date(offset.getTime() + i * seconds),
        y: value,
      })),
    }));
  }
}

export default HourlyBase;
