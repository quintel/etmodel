var MeritOrderExcessData = (function () {
    'use strict';

    return {
        set: function (data) {
            this.data = data;
            this.formatted = undefined;

            return this;
        },

        format: function () {
            if (!this.formatted) {
                this.formatted = {
                    key:    this.data[0].attributes.gquery_key,
                    values: this.data[0].future_value(),
                    color:  this.data[0].attributes.color
                };
            }

            return this.formatted;
        },

        /* Public scope of MeritOrderExcessData
         *
         * Checks if the first Y value of the merit order excess data
         * is larger than 1. In other words; checks if there are excess
         * events which are longer than 1 hour.
         */
        isEmpty: function () {
            return this.formatted.values[0][1] <= 0;
        },

        maxX: function () {
            return d3.max(_.map(this.format().values, function (e) {
                return e[0];
            }));
        },

        maxY: function () {
            return d3.max(_.map(this.format().values, function (e) {
                return e[1];
            }));
        }
    };
}());
