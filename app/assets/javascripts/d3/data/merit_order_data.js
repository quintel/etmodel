/* globals _ $ d3 */

var MeritOrderData = (function () {
  'use strict';

  function operatingCosts(queryValues) {
    return queryValues.type === 'must_run' || queryValues.capacity <= 0 ? 0 : undefined;
  }

  return {
    set: function (data) {
      this.data = data;
      this.formatted = undefined;

      return this;
    },

    formatItem: function (item) {
      var future = item.future_value();
      var load_factor;

      if (future.load_factor) {
        load_factor = future.load_factor;
      }

      return $.extend(future, {
        color: item.attributes.color,
        key: item.attributes.gquery_key.replace(/_merit_order$/, ''),
        label: item.attributes.label,
        load_factor: load_factor,
        operating_costs: operatingCosts(item),
      });
    },

    format: function () {
      if (!this.formatted) {
        this.formatted = [];
        this.formatted = this.data.map(this.formatItem.bind(this));
      }

      return this.formatted;
    },

    legendData: function () {
      return _.reject(this.data, function (item) {
        return item.future_value().capacity <= 0;
      });
    },

    maxHeight: function () {
      return d3.max(
        _.map(this.format(), function (d) {
          return d.operating_costs;
        })
      );
    },

    totalWidth: function () {
      return d3.sum(
        _.map(this.format(), function (d) {
          return d.capacity;
        })
      );
    },
  };
})();
