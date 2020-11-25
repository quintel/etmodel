import Line from './Line';

/**
 * ElectricityNetworkLoad is identical to Line, except that any series whose key contains "supply"
 * is inverted (positives become negative).
 */
class ElectricityNetworkLoad extends Line {
  visibleData() {
    return super.visibleData().map((serie) => {
      if (serie.key.match(/supply/)) {
        return Object.assign({}, serie, { values: serie.values.map((v) => -v) });
      }

      return serie;
    });
  }
}

export default ElectricityNetworkLoad;
