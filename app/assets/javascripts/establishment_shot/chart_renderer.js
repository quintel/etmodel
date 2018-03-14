EstablishmentShot.ChartRenderer = (function () {
    'use strict';

    function mergeSeries(series, data) {
        series.forEach(function(serie) {
            serie.value = data.gqueries[serie.key].present;
            serie.unit  = data.gqueries[serie.key].unit;
        });

        return series;
    }

    return {
        render: function (scope, data) {
            var chart,
                chartScope,
                info;

            $('div[data-chart]').each(function () {
                chart = $(this).data('chart');
                info  = EstablishmentShot.Charts.charts[chart];

                new info.type($(this), mergeSeries(info.series, data)).render();
            });
        }
    }
}());
