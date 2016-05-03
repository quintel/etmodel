var Downsampler = (function () {
    'use strict';

    return {
        downsample: function (serie) {
            var values,
                total,
                result     = [],
                daysInYear = 365,
                hoursInDay = 24;

            for (var d = 0; d < daysInYear; d++) {
                values = serie.oldValues.slice(d * hoursInDay, (d + 1) * hoursInDay),
                total  = d3.sum(values.map(function (point) {
                    return point.y;
                }));

                result.push({
                    x: new Date(d * 24 * 60 * 60 * 1000),
                    y: (total / hoursInDay)
                });
            }

            return result;
        }
    }
}());
