EstablishmentShot.TextUpdater = (function () {
    'use strict';

    var UNITS = {
        factor: '%'
    };

    return {
        update: function (scope, data) {
            var query,
                value,
                unit;

            for (query in data.gqueries) {
                unit  = data.gqueries[query].unit
                value = data.gqueries[query].present;

                if (UNITS[unit]) {
                    unit = UNITS[unit];
                }

                $("[data-query='" + query + "']").text(
                    (Math.round(value * 100) / 100) + ' ' + unit
                );
            }
        }
    }
}());
