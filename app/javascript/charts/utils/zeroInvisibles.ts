interface ZeroableSeries {
  hidden: boolean;
  values: number[];
}

export const zeroInvisibleSerie = (data: ZeroableSeries): ZeroableSeries => {
  if (data.hidden) {
    data.values = data.values.map(() => 0);
  }

  return data;
};

/**
 * Takes an array of series data and zeros its values when the "hidden" property is set. Modifies
 * the original values in place.
 */
export default (series: ZeroableSeries[]): ZeroableSeries[] => {
  return series.map((data) => zeroInvisibleSerie(data));
};
