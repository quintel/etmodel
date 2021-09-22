import { max, mean } from 'd3-array';

type DownsampleFunc = (values: number[]) => number;

export type DownsampleMethodKey = 'max' | 'mean';
export type DownsampleOption = DownsampleFunc | DownsampleMethodKey;

// The number of days from the start of the year to the beginning of each month.
export const cumulativeDaysPerMonth = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];

function downsampleFunc(name: DownsampleOption): DownsampleFunc {
  if (typeof name === 'function') {
    return name;
  }

  return name == 'max' ? max : mean;
}

/**
 * Given an array of values representing samples of annual data, produces a downsampled version with
 * each new value representing the mean for each day.
 *
 * @param values           - Array of values to downsample.
 * @param downsampleMethod - A function used to downsample the values, or the string "max" or
 *                           "mean".
 */
const downsample = (values: number[], downsampleMethod: DownsampleOption): number[] => {
  const result = [];

  for (let day = 0; day < 365; day++) {
    result.push(downsampleFunc(downsampleMethod)(values.slice(day * 24, (day + 1) * 24)));
  }

  return result;
};

/**
 * Given an array of values representing samples of annual data, one for each hour, produces the
 * data for the weekNum.
 *
 * @param values  - Array of values.
 * @param weekNum - Number of the week to extract. Jan 1-7: 1, Jan 8-14: 2, etc.
 */
const sliceWeek = (values: number[], weekNum: number) => {
  const weekLen = Math.floor(values.length / 365) * 7;
  return values.slice((weekNum - 1) * weekLen, weekNum * weekLen);
};

/**
 * Given an array of values representing samples of annual data, one for each hour, returns a new
 * array containing all the values for a month.
 *
 * @param values   - Array of values.
 * @param monthNum - Number of the month whose data to extract. Zero indexed (1=Jan, 2=Feb, etc).
 */
const sliceMonth = (values: number[], monthNum: number) => {
  const dayLength = values.length / 365;

  const startDay = cumulativeDaysPerMonth[monthNum - 1];
  const endDay = cumulativeDaysPerMonth[monthNum] || 365;

  return values.slice(startDay * dayLength, endDay * dayLength);
};

export interface SampleCurveOptions {
  weekNum?: number;
  monthNum?: number;
  downsampleMethod?: DownsampleOption;
}

/**
 * Slices values according to the given week or month number.
 */
export const sliceValues = (
  values: number[],
  { weekNum, monthNum }: SampleCurveOptions
): number[] => {
  if (weekNum != undefined) {
    return sliceWeek(values, weekNum);
  }

  if (monthNum != undefined) {
    return sliceMonth(values, monthNum);
  }

  throw new Error('Cannot slice curve values without a weekNum or monthNum');
};

/**
 * A default transform action which receives the values and options, and returns the values
 * transformed according to the options.
 */
export default (values: number[], opts: SampleCurveOptions): number[] => {
  if (values.length === 0) {
    return [];
  }

  if (opts.weekNum == undefined && opts.monthNum == undefined) {
    return downsample(values, opts.downsampleMethod);
  }

  return sliceValues(values, opts);
};
