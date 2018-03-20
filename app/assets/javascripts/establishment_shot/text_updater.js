EstablishmentShot.TextUpdater = (function () {
    'use strict';

    var UNITS = {
        factor: '%'
    };

    function quantityFrom(query) {
        if (Quantity.isSupported(query.unit)) {
            return new Quantity(query.present, query.unit).smartScale();
        } else {
            return { value: query.present, unit: { name: query.unit } };
        }
    }

    return {
        update: function (scope, data) {
            var value,
                unit,
                quantity;

            $("[data-query]").each(function () {
                quantity = quantityFrom(data.gqueries[$(this).data('query')]);

                unit  = quantity.unit.name;
                value = quantity.value;

                if (UNITS[unit]) {
                    unit = UNITS[unit];
                }

                $(this).text((Math.round(value * 100) / 100) + ' ' + unit);
            });
        }
    }
}());
