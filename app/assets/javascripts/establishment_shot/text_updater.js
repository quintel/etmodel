EstablishmentShot.TextUpdater = (function () {
    'use strict';

    var UNITS = {
        factor: '%'
    };

    function quantityFrom(query, time) {
        var value;
        if (time == 'present'){
            value = query.present;
        } else if (time == 'future'){
            value = query.future;
        }

        if (Quantity.isSupported(query.unit)) {
            return new Quantity(value, query.unit).smartScale();
        } else {
            return { value: value, unit: { name: query.unit } };
        }
    }

    return {
        update: function (scope, data, time) {
            var value,
                unit,
                quantity;

            $("[data-query]").each(function () {
                quantity = quantityFrom(data.gqueries[$(this).data('query')], time);

                unit  = quantity.unit.name;
                value = quantity.value;

                if (UNITS[unit]) {
                    unit = UNITS[unit];
                } else if (!$(this).data('unit')){
                    unit = '';
                }

                $(this).text((Math.round(value * 100) / 100).toLocaleString() + ' ' + unit);
            });
        }
    }
}());
