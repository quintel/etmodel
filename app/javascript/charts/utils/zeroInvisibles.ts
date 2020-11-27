interface ZeroableSeries {
  skip: boolean;
  values: number[];
}

export const zeroInvisibleSerie = (data: ZeroableSeries): ZeroableSeries => {
  if (data.skip) {
    data.values = data.values.map(() => 0);
  }

  return data;
};

/**
 * Takes an array of series data and zeros its values when the "skip" property is set. Modifies the
 * original values in place.
 */
export default (series: ZeroableSeries[]): ZeroableSeries[] => {
  return series.map((data) => zeroInvisibleSerie(data));
};
