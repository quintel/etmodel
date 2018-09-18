var MeritOrderData = (function () {
    'use strict';

    function capacityOverZero(item) {
        return item.future_value().capacity <= 0;
    }

    return {
        set: function (data) {
            this.data = data;
            this.formatted = undefined;

            return this;
        },

        operatingCosts: function () {
            if (this.attributes.gquery_key === 'must_run_merit_order' ||
                capacityOverZero(this)) {

                return 0;
            } else {
                return this.attributes.operating_costs;
            }
        },

        formatItem: function (item) {
            var future = item.future_value();
            var load_factor = null;

            if (future.load_factor) {
                load_factor = future.load_factor;
            }

            this.formatted.push($.extend(future, {
                color:           item.attributes.color,
                key:             item.attributes.gquery_key.replace(/\_merit_order$/, ''),
                label:           item.attributes.label,
                load_factor:     load_factor,
                operating_costs: this.operatingCosts.call(item)
            }));
        },

        format: function () {
            if (!this.formatted) {
                this.formatted = [];
                this.data.forEach(this.formatItem.bind(this));
            }

            return this.formatted;
        },

        legendData: function () {
            return _.reject(this.data, capacityOverZero);
        },

        maxHeight: function () {
            return d3.max(_.map(this.format(), function (d) {
                return d.operating_costs;
            }));
        },

        totalWidth: function () {
            return d3.sum(_.map(this.format(), function (d) {
                return d.capacity;
            }));
        }
    };
}());
