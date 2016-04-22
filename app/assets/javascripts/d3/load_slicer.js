var LoadSlicer = (function () {
    'use strict';

    function sliceValues(serie) {
        var range = this.dateSelect.getCurrentRange();

        if (this.dateSelect.val() > 0) {
            return _.filter(serie.oldValues, function (value) {
                return value.x >= (range[0] - 1) && value.x < range[1];
            });
        } else {
            return serie.oldValues;
        }
    }

    return {
        slice: function (serie) {
            if (!(serie.oldValues)) {
                serie.oldValues = serie.values;
            }

            serie.values = sliceValues.call(this, serie);

            return serie;
        }
    };
}());
