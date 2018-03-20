EstablishmentShot.BarChart = (function () {
    'use strict';

    function drawLegend() {
        var key,
            item,
            square,
            listItem,
            legend = $('<div/>').addClass('legend'),
            list   = $('<ul/>');

        this.data.forEach(function (serie) {
            listItem = $('<li/>');
            square   = $('<i/>')
                .addClass('fa fa-square')
                .css('color', serie.color);

            listItem.append(square, I18n.t('establishment_shot.legend.' + serie.key));
            list.prepend(listItem);
        });

        legend.append(list);
        this.scope.append(legend);
    }

    function calculateMax(data) {
        return d3.sum(data.map(function(serie) {
            return serie.value;
        })) * 1.05;
    }

    BarChart.prototype = {
        render: function () {
            var info = EstablishmentShot.Charts.charts[this.scope.data('chart')],
                unit = this.data[0].unit;

            window.stackedBarChart(
                this.scope[0],
                {
                    width:  info.width,
                    height: info.height,
                    series: this.data,
                    title:  I18n.t('establishment_shot.charts.' + this.scope.data('chart')),
                    margin: info.margin,
                    max:    calculateMax(this.data),
                    formatValue: function (d) {
                        return d + ' ' + unit;
                    }
                }
            );

            drawLegend.call(this);
        }
    }

    function BarChart(scope, data) {
        this.scope = scope;
        this.data  = data;
    }

    return BarChart;
}());
