var LoadSlicer = (function () {
    'use strict';

    return {
        slice: function sliceValues(serie, range) {
            return serie.values.slice((range * 168), (range + 1) * 168);
        }
    };
}());
