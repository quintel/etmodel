var LoadSlicer = (function () {
    'use strict';

    return {
        slice: function sliceValues(serie, range) {
            return _.filter(serie.oldValues, function (value) {
                return value.x >= (range[0] - 1) && value.x < range[1];
            });
        }
    };
}());
