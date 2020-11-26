import type { DownsampleMethodKey, SampleCurveOptions } from './sampleCurves';
import { cumulativeDaysPerMonth } from './sampleCurves';

const epoch = new Date(Date.UTC(1970, 0, 1));

const secondsPerHour = 60 * 60;
const msPerHour = secondsPerHour * 1000;
const msPerDay = msPerHour * 24;
const msPerWeek = msPerDay * 7;

/**
 * Builds an HTMLOptionElement to be displayed in the select.
 *
 * @param period The period represented by the option. "all" shows all data, "month" and "week" will
 *               show data for a selected month or week.
 * @param text   Text content for the option.
 * @param config An optional num (required if period is "month" or "week"), and key to be used to
 *               set the option value.
 */
const buildOption = (
  period: 'all' | 'month' | 'week',
  text: string,
  { num, key }: { num?: number; key?: string }
) => {
  const option = document.createElement('option');

  option.value = key ? key : `${period},${num}`;
  option.textContent = text;

  return option;
};

/**
 * Given a week number, returns the range of dates contained in the week.
 */
const weekRange = (weekNum: number): [Date, Date] => {
  const msOffset = msPerWeek * (weekNum - 1);
  const start = new Date(epoch.getDate() + msOffset);

  // Remove an hour from the end of the range to as the range should be 00:00
  // to 23:00, not 00:00 to 00:00.
  const end = new Date(start.getDate() + msOffset + msPerWeek - msPerHour);

  return [start, end];
};

/**
 * Builds an HTMLOptionElement representing a single week, identified by a number (first week is 0),
 * second week is 1, etc.
 */
const buildWeekOption = (weekNum: number) => {
  return buildOption('week', weeklyOptionText(...weekRange(weekNum)), { num: weekNum });
};

const weeklyOptionText = (start: Date, end: Date) => {
  return I18n.strftime(start, '%-d %b') + ' - ' + I18n.strftime(end, '%-d %b');
};

/**
 * Given a month number, returns the range of dates contained in the week.
 */
const monthRange = (monthNum: number): [Date, Date] => {
  const startDay = cumulativeDaysPerMonth[monthNum - 1];
  const endDay = cumulativeDaysPerMonth[monthNum] || 365;

  const start = new Date(epoch.getDate() + msPerDay * startDay);

  // Remove an hour from the end of the range to as the range should be 00:00
  // to 23:00, not 00:00 to 00:00.
  const end = new Date(epoch.getDate() + msPerDay * endDay - msPerHour);

  return [start, end];
};

/**
 * Builds an HTMLOptionElement representing a single month, identified by a number (January = 0,
 * February = 1, etc).
 */
const buildMonthOption = (monthNum: number) => {
  return buildOption('month', monthlyOptionText(monthRange(monthNum)[0]), { num: monthNum });
};

const monthlyOptionText = (start: Date) => {
  return I18n.strftime(start, '%B');
};

/**
 * Builds ah HTMLOptionElement for showing data from whole year.
 */
const buildYearlyOption = (downsampleMethod: string) => {
  const textNamespace = 'output_elements.common.';

  const yearText = I18n.t(textNamespace + 'whole_year_daily_' + downsampleMethod, {
    defaultValue: I18n.t(textNamespace + 'whole_year'),
  });

  return buildOption('all', yearText, { key: 'all' });
};

/**
 * Builds an optgroup which contains HTMLOptions.
 */
const buildOptGroup = (label: string, options: HTMLOptionElement[]): HTMLOptGroupElement => {
  const optgroup = document.createElement('optgroup');
  optgroup.label = label;

  for (const option of options) {
    optgroup.append(option);
  }

  return optgroup;
};

/**
 * Creates the list of HTMLOptionElement which are shown in the select.
 */
const buildOptions = (downsampleMethod: string) => {
  const options: (HTMLOptionElement | HTMLOptGroupElement)[] = [
    buildYearlyOption(downsampleMethod),
  ];

  const monthOptions = [];
  const weekOptions = [];

  for (let i = 1; i <= 12; i++) {
    monthOptions.push(buildMonthOption(i));
  }

  for (let i = 1; i <= 52; i++) {
    weekOptions.push(buildWeekOption(i));
  }

  options.push(buildOptGroup(I18n.t('output_elements.common.months'), monthOptions));
  options.push(buildOptGroup(I18n.t('output_elements.common.weeks'), weekOptions));

  return options;
};

/**
 * Builds an HTMLSelectElement which holds the various time options which may be selected by the
 * user.
 */
const buildSelectElement = (downsampleMethod: string) => {
  const select = document.createElement('select');

  select.classList.add('d3-chart-date-select');
  select.append(...buildOptions(downsampleMethod));
  select.value = App.settings.get('merit_charts_date') || 'all';

  return select;
};

/**
 * Parses a DateSelect value, returning the selected date period ("all", "month", "week") and the
 * month or week number.
 */
const parseSelectedDate = (selectedValue: string): [Date, Date] => {
  const [period, numStr] = selectedValue.split(',');

  if (period === 'all') {
    return [epoch, new Date(epoch.getDate() + msPerDay * 365 - msPerHour)];
  }

  if (typeof numStr === undefined) {
    throw new TypeError(`Unparseable selected date: ${selectedValue}`);
  }

  const num = Number.parseInt(numStr, 10);

  if (period === 'week') {
    return weekRange(num);
  } else if (period === 'month') {
    return monthRange(num);
  } else {
    throw new Error(`Unparseable selected date: ${selectedValue}`);
  }
};

/**
 * Builds and manages a <select> from which a user may choose a date range to be shown in hourly
 * charts.
 */
class DateSelect {
  private updateChart: () => void;
  private selectEl: HTMLSelectElement;
  private wrapper: HTMLDivElement;
  private downsampleMethod: DownsampleMethodKey;

  constructor(wrapper: HTMLDivElement, downsampleMethod: DownsampleMethodKey) {
    this.wrapper = wrapper;
    this.downsampleMethod = downsampleMethod;
  }

  /**
   * Draws the select element.
   *
   * @param updateChart A function which will be called whenever the value of the select element
   *                    changes.
   */
  draw(updateChart: () => void): void {
    this.updateChart = updateChart;
    this.selectEl = buildSelectElement(this.downsampleMethod);

    this.wrapper.append(this.selectEl);

    App.settings.on('change:merit_charts_date', this.updateDate);
    this.selectEl.addEventListener('change', this.triggerUpdate);
  }

  updateDate = (_settings: unknown, value: string): void => {
    if (this.selectEl.value !== value) {
      this.selectEl.value = value;
      this.updateChart && this.updateChart();
    }
  };

  /**
   * Removes bound events ready for the component to be removed.
   */
  remove = (): void => {
    App.settings.off('change:merit_charts_date', this.updateDate);
    this.selectEl.remove();
  };

  triggerUpdate = (): void => {
    App.settings.set('merit_charts_date', this.selectEl.value);
    this?.updateChart();
  };

  /**
   * Returns options to be passed to sampleCurves in order to extract the data for the selected date
   * range.
   */
  toTransformOptions(): SampleCurveOptions {
    const [period, numStr] = this.selectEl.value.split(',');

    if (period === 'all' || !numStr) {
      return { downsampleMethod: this.downsampleMethod };
    } else if (period === 'month') {
      return { monthNum: Number.parseInt(numStr) };
    }

    return { weekNum: Number.parseInt(numStr) };
  }

  currentRange(): [Date, Date] {
    return parseSelectedDate(this.selectEl.value);
  }

  startDate(): Date {
    return parseSelectedDate(this.selectEl.value)[0];
  }

  endDate(): Date {
    return parseSelectedDate(this.selectEl.value)[1];
  }

  /**
   * Returns if the current selection is to show the entire range of data.
   */
  isAll(): boolean {
    return this.selectEl.value.startsWith('all');
  }

  /**
   * Returns if the current selection is to show data for a month.
   */
  isMonthly(): boolean {
    return this.selectEl.value.startsWith('month');
  }

  /**
   * Returns if the current selection is to show data for a week.
   */
  isWeekly(): boolean {
    return this.selectEl.value.startsWith('week');
  }

  /**
   * Returns the number of seconds represented by each data-point at the selected date setting. When
   * showing data for an entire year, each data-point will summarise an entire day; otherwise each
   * point is for an hour.
   */
  secondsPerSample(): number {
    return this.isAll() ? secondsPerHour * 24 : secondsPerHour;
  }

  /**
   * Returns an array of dates which should be shown in the time axis, based
   * on the currently-selected week.
   */
  tickValues(): Date[] {
    // const values = [];

    // if (this.isWeekly()) {
    //   const startDate = this.weeks[this.val()][0];
    //   const msPerDay = 1000 * 60 * 60 * 24;

    //   for (const i = 0; i < 7; i++) {
    //     values.push(new Date(startDate.getTime() + msPerDay * i));
    //   }
    // } else {
    //   for (const j = 0; j < 12; j++) {
    //     values.push(new Date(Date.UTC(1970, j, 1)));
    //   }
    // }

    // return values;
    const values = [];

    if (this.isWeekly()) {
      const startDate = this.startDate();

      for (let i = 0; i < 7; i++) {
        values.push(new Date(startDate.getTime() + msPerDay * i));
      }
    } else if (this.isMonthly()) {
      let startDate = this.startDate();
      const endDate = this.endDate();

      while (startDate < endDate) {
        values.push(startDate);
        startDate = new Date(startDate.getTime() + msPerWeek);
      }
    } else {
      for (let j = 0; j < 12; j++) {
        values.push(new Date(Date.UTC(1970, j, 1)));
      }
    }

    return values;
  }
}

export default DateSelect;

// const D3ChartDateSelect = (function() {
//   'use strict';

//   function buildSelectEl(downsampleMethod) {
//     return $('<select/>')
//       .addClass('d3-chart-date-select')
//       .append(createOptions.call(this, downsampleMethod))
//       .val(App.settings.get('merit_charts_date') || '0')
//       .on('change', setMeritChartsDate);
//   }

//   D3ChartDateSelect.prototype = {
//     selectEl: undefined,
//     weeks: [[epoch, new Date(1970, 11, 31, 1)]],

//     draw: function(updateChart) {
//       this.updateChart = updateChart;
//       this.selectEl = buildSelectEl.call(this, this.downsampleMethod);

//       this.scope.append(this.selectEl);

//       App.settings.on('change:merit_charts_date', updateMeritChartsDate.bind(this));
//     },

//     getCurrentRange: function() {
//       return this.weeks[this.val()];
//     },

//     /**
//      * Returns an array of dates which should be shown in the time axis, based
//      * on the currently-selected week.
//      */
//     tickValues: function() {
//       const values = [];

//       if (this.isWeekly()) {
//         const startDate = this.weeks[this.val()][0];
//         const msPerDay = 1000 * 60 * 60 * 24;

//         for (const i = 0; i < 7; i++) {
//           values.push(new Date(startDate.getTime() + msPerDay * i));
//         }
//       } else {
//         for (const j = 0; j < 12; j++) {
//           values.push(new Date(Date.UTC(1970, j, 1)));
//         }
//       }

//       return values;
//     },

//     val: function() {
//       return parseInt(this.selectEl.val(), 10);
//     },

//     isWeekly: function() {
//       return this.val() > 0;
//     }
//   };

//   function D3ChartDateSelect(scope, range, downsampleMethod) {
//     this.scope = $(scope);
//     this.range = range;
//     this.downsampleMethod = downsampleMethod;
//   }

//   return D3ChartDateSelect;
// })();
