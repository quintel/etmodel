EstablishmentShot.ChartRenderer = (function () {
    'use strict';

    function quantityFrom(query, time) {
        var value;
        if (time == 'present'){
            value = query.present;
        } else if (time == 'future'){
            value = query.future;
        }
        return new Quantity(value, query.unit);
    }

    function mergeSeries(info, data, time) {
        var i,
            quantity,
            unit,
            maxMultiple = 0,
            result = [];

        // Determine the max unit
        info.series.forEach(function (serie) {
            quantity = quantityFrom(data.gqueries[serie.key], time).smartScale();

            if (quantity.unit.power.multiple > maxMultiple) {
                unit        = quantity.unit;
                maxMultiple = unit.power.multiple;
            }
        });

        // Convert the series to the max unit
        return info.series.map(function (serie, i) {
            quantity = quantityFrom(data.gqueries[serie.key], time).to(unit.name);

            serie.value = quantity.value;
            serie.unit  = unit.name;
            serie.color = info.color_gradient[i];

            return serie;
        });
    }

    return {
        render: function (scope, data, time) {
            var chart,
                chartScope,
                info;

            $('div[data-chart]').each(function () {
                chart = $(this).data('chart');
                info  = EstablishmentShot.Charts.charts[chart];

                new info.type($(this), mergeSeries(info, data, time)).render();
            });
        }
    }
}());
