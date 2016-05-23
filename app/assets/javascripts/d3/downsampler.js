var Downsampler = (function () {
    'use strict';

    return {
        downsample: function (serie) {
            var values,
                result     = [],
                daysInYear = 365,
                hoursInDay = 24;

            for (var d = 0; d < daysInYear; d++) {
                values = serie.values.slice(d * hoursInDay, (d + 1) * hoursInDay),

                result.push(d3.mean(values));
            }

            return result;
        }
    }
}());
