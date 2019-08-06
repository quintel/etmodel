/* globals _ */

// eslint-disable-next-line no-unused-vars
var MeritOrder = {
  /**
   * Given the "dashboard_profitability" query future value, calculates the
   * value to be shown in the dashboard.
   */
  dashboardValue: function(queryData) {
    if (!this.canCalculate(queryData)) {
      return null;
    }

    return (
      this.profitableCapacity(queryData) /
      this.totalAvailableCapacity(queryData)
    );
  },

  /**
   * Checks the query data to find out if the dashboard value can be calculated.
   */
  canCalculate: function(queryData) {
    return (
      queryData &&
      _.values(queryData).filter(function(producer) {
        return producer.profitability !== null;
      }).length > 0 &&
      this.totalAvailableCapacity(queryData) > 0
    );
  },

  /**
   * Determines the capacity of all producers.
   */
  totalAvailableCapacity: function(queryData) {
    return this.sumValues(queryData, function(producer) {
      return producer.capacity;
    });
  },

  /**
   * Determines the capacity of producers whose status is profitable.
   */
  profitableCapacity: function(queryData) {
    return this.sumValues(queryData, function(producer) {
      if (producer.profitability !== 'profitable') {
        return 0.0;
      }

      return producer.capacity;
    });
  },

  /**
   * Iterates through each producer in the query, running `iter` on each and
   * summing the returned values.
   */
  sumValues: function(queryData, iter) {
    return _.values(queryData).reduce(function(sum, producer) {
      return sum + iter(producer);
    }, 0.0);
  }
};
