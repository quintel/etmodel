var MeritOrderData = (function () {
    'use strict';

    return {
        set: function (data) {
            this.data = data;
            this.formatted = undefined;

            return this;
        },

        operatingCosts: function () {
            if (this.attributes.gquery_key === 'must_run_merit_order') {
                return 0;
            } else {
                return this.attributes.operating_costs;
            }
        },

        formatItem: function (item) {
            var future = item.future_value();

            this.formatted.push($.extend(future, {
                color:           item.attributes.color,
                key:             item.attributes.gquery_key.replace(/\_merit_order$/, ''),
                load_factor:     Metric.ratio_as_percentage(future.load_factor),
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
