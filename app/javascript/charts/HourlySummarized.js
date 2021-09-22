/* globals App I18n */

import * as d3 from './d3';
import D3Chart from './D3Chart';
import { groupedStack } from './utils/stackData';
import negativeRegionRect from './utils/negativeRegionRect';

const stack = d3.stack().offset(d3.stackOffsetDiverging);

/**
 * Options for reducing monthly values to a single value.
 */
const reducerFunctions = {
  first: (values) => values[0],
  last: (values) => values[values.length - 1],
  max: d3.max,
  mean: d3.mean,
  median: d3.mean,
  min: d3.min,
  sum: d3.sum,
};

/**
 * Values shown in the chart must be converted from the individual hourly values, to a summary shown
 * for each month. Contributors may choose whether to show the sum of all values in the month, or
 * the peak, and may opt for the value to be transformed (for example from MW to MJ).
 *
 * Receives a configuration, and returns a function which will reduce slices of hourly values to a
 * single value.
 *
 * @return {function}
 */
const buildSliceReducer = ({ unit, originalUnit = '', reduceWith = 'sum' }) => {
  let multiplier = 1;
  const reducer = reducerFunctions[reduceWith];

  if (!reducer) {
    throw new Error(`No such reduceWith option: ${reduceWith}`);
  }

  if (originalUnit && originalUnit !== unit) {
    const mwMatch = originalUnit.toString().match(/^(\w)Wh?$/);

    if (mwMatch && unit === `${mwMatch[1]}J`) {
      multiplier = 3600;
    } else {
      throw new Error(`HourlySummarized cannot convert from ${originalUnit} to ${unit}`);
    }
  }

  return (values) => reducer(values) * multiplier;
};

/**
 * Receives a Chart model and creates a slice reducer from its config. See buildSliceReducer.
 */
const buildSliceReducerFromModel = (model) => {
  const { original_unit: originalUnit, reduce_with: reduceWith } = model.get('config');
  const unit = model.get('unit');

  return buildSliceReducer({ originalUnit, reduceWith, unit });
};

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
 * Given a linked chart and month number (zero indexed), loads the chart at the chosen month.
 */
const loadLinkedChart = (key, month) => {
  App.settings.set('merit_charts_date', `month,${month + 1}`);

  if (!App.charts.chart_already_on_screen(key)) {
    App.charts.load(key);
  }
};

/**
 * Return a function which may be used to check if a serie (the data returned by the D3 selection)
 * linked to another chart.
 *
 * @param {Chart} chart
 *   The chart model.
 * @param {(serieKey: string, attribute: string) => string}
 *   A function which receives a serie key and attribute to be looked up, and returns the attribute.
 *   Typically the view's serieValue method.
 *
 * @return {(legendKey: { key: string }) => boolean}
 */
const buildIsLinkedSerie = (chart, lookup) => {
  let set = new Set();

  if (typeof chart.get('config').linked_chart === 'object') {
    set = new Set(Object.keys(chart.get('config').linked_chart));
  }

  return (d) => set.has(lookup(d.key, 'label_key'));
};

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
 *
 * The chart may be customised to display either the sum of values for a month, or the peak value.
 * It also allows converting values to W to J and Wh to J.
 *
 * ### Converting from W to J
 *
 * The chart config must contain a "unit" and "config.original_unit":
 *
 *   - key: my_chart_key
 *     output_element_type_name: hourly_summarized
 *     unit: MJ
 *     config:
 *       original_unit: MW
 *
 * Both the "unit" and "config.original_unit" must have the same order of magnitude (W and J, MW and
 * MJ, etc).
 *
 * ### Selecting the peak monthly value
 *
 * While the chart defaults to showing the sum of all hourly values for a month, you may instead opt
 * to show the peak value for each month by setting "config.reduce_with" to "max".
 *
 *     - key: my_chart_key
 *       output_element_type_name: hourly_summarized
 *       config:
 *         reduce_with: max
 */
class HourlySummarized extends D3Chart {
  tickCount = 5;

  margins = {
    top: 20,
    right: 0,
    bottom: 20,
    left: 50,
  };

  /**
   * Items in the legend may be clicked to hide the series.
   */
  clickableLegend = true;

  /**
   * Event triggered whenever the user clicks a month group.
   */
  onMonthSelect = ({ currentTarget }) => {
    const linkedChart = this.model.get('config').linked_chart;

    if (typeof linkedChart !== 'string') {
      return false;
    }

    const monthNum = Number.parseInt(currentTarget.dataset.month, 10);

    if (Number.isNaN(monthNum)) {
      return false;
    }

    loadLinkedChart(linkedChart, monthNum);
  };

  /**
   * Event triggered whenever the user clicks a serie <rect>. Does nothing if the chart does not
   * have per-serie linked_chart config.
   */
  onSerieSelect = ({ currentTarget }, { key }) => {
    const linkedChartConf = this.model.get('config').linked_chart;

    if (typeof linkedChartConf !== 'object') {
      return false;
    }

    const group = currentTarget.closest('.date-group');
    const monthNum = Number.parseInt(group.dataset.month, 10);
    const labelKey = this.serieValue(key, 'label_key');

    if (Number.isNaN(monthNum)) {
      return false;
    }

    const linkedChart = linkedChartConf[labelKey];

    if (linkedChart) {
      loadLinkedChart(linkedChart, monthNum);
    }
  };

  draw() {
    [this.width, this.height] = this.dimensions();

    const groupNames = groupKeys(this.model.non_target_series());

    this.stackLabelHeight = groupNames.length > 1 ? 60 : 0;
    this.height += this.stackLabelHeight;
    this.seriesHeight = this.height - this.stackLabelHeight;

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
      .attr(
        'class',
        `date-group ${typeof this.model.get('config').linked_chart === 'string' ? 'linked' : ''}`
      )
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
      })
      .on('click', this.onSerieSelect);

    // Contains legend keys which are linked to another chart.
    let isLinkedSerie = buildIsLinkedSerie(this.model, this.serieValue);

    // Finally join each datapoint for a series (the seriesKey, typically present and future years).
    series
      .selectAll('rect.serie')
      .data(
        (d) => d,
        (d, i) => `${d.key}-${i}`
      )
      .join('rect')
      .attr('class', (d) => {
        return isLinkedSerie(d) ? 'serie linked' : 'serie';
      })
      .attr('x', (d) => this.stackScale(d.data.x))
      .attr('y', this.seriesHeight)
      .attr('width', this.stackScale.bandwidth())
      .attr('height', 0)
      .attr('y', (d) => this.yScale(d[1]))
      .attr('height', (d) => this.yScale(d[0]) - this.yScale(d[1]))
      .attr('data-tooltip-title', (d) => {
        const groupKey = this.serieValue(d.key, 'group');

        if (groupKey) {
          const groupName = ` - ${I18n.t(`output_element_series.groups.${groupKey}`)}`;
          return `${this.serieValue(d.key, 'label')}${groupName}`;
        } else {
          return `${this.serieValue(d.key, 'label')}`;
        }
      });

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
    const data = groupedStack(this.prepareData(), stack);

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
      .transition(transition)
      .attr('y', (d) => (d[0] > d[1] ? this.yScale(d[0]) : this.yScale(d[1])))
      .attr('height', (d) => Math.abs(this.yScale(d[0]) - this.yScale(d[1])))
      .attr('data-tooltip-text', (d) => this.formatValue(Math.abs(d[1]) - Math.abs(d[0])));

    this.updateNegativeRegion(this.yScale, transition);
  }

  prepareData() {
    const values = [];
    const reducer = buildSliceReducerFromModel(this.model);

    this.model.non_target_series().forEach((serie) => {
      const base = {
        id: serie.get('gquery').get('key'),
        stackKey: serie.get('group'),
        x: serie.get('group'),
      };

      values.push(
        ...sliceToMonth(serie.safe_future_value()).map((monthVals, groupKey) => {
          let reduced = reducer(monthVals);

          if (serie.get('hidden')) {
            // A hidden series which would be below zero is given a tiny value to prevent D3 from
            // animating a transition to a non-negative value (0). Without this the chart serie
            // appear to fly upwards towards zero.
            reduced *= 1e-30;
          }

          return Object.assign({}, base, { groupKey, y: reduced });
        })
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
        datum.forEach(([lower, upper]) => {
          maxValue = Math.max(maxValue, Math.abs(lower), upper);
        });
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
