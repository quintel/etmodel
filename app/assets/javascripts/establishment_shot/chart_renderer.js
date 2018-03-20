EstablishmentShot.ChartRenderer = (function () {
    'use strict';

    function quantityFrom(query) {
        return new Quantity(query.present, query.unit);
    }

    function mergeSeries(info, data) {
        var i,
            quantity,
            unit,
            maxMultiple = 0,
            result = [];

        // Determine the max unit
        info.series.forEach(function (serie) {
            quantity = quantityFrom(data.gqueries[serie.key]).smartScale();

            if (quantity.unit.power.multiple > maxMultiple) {
                unit        = quantity.unit;
                maxMultiple = unit.power.multiple;
            }
        });

        // Convert the series to the max unit
        return info.series.map(function (serie, i) {
            quantity = quantityFrom(data.gqueries[serie.key]).to(unit.name);

            serie.value = quantity.value;
            serie.unit  = unit.name;
            serie.color = info.color_gradient[i];

            return serie;
        });
    }

    return {
        render: function (scope, data) {
            var chart,
                chartScope,
                info;

            $('div[data-chart]').each(function () {
                chart = $(this).data('chart');
                info  = EstablishmentShot.Charts.charts[chart];

                new info.type($(this), mergeSeries(info, data)).render();
            });
        }
    }
}());
