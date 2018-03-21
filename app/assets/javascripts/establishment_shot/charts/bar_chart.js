EstablishmentShot.BarChart = (function () {
    'use strict';

    function mouseover() {
        var chart = $(this).parents('.chart'),
            item = $(this).attr('class');

        chart.find('g.series').stop().animate({ 'opacity': 0.3 });
        chart.find('g.series.' + item).stop().animate({ 'opacity': 1.0 });
    }

    function mouseout() {
        var chart = $(this).parents('.chart');

        chart.find('g.series').stop().animate({ 'opacity': 1.0 });
    }

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

            if (serie.value > 0) {
                listItem.on('mouseover', mouseover).on('mouseout', mouseout);
            }

            listItem
                .addClass(serie.key)
                .attr('title', serie.value + ' ' + serie.unit)
                .append(square, I18n.t('establishment_shot.legend.' + serie.key));

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
            var chart = this.scope.data('chart'),
                info = EstablishmentShot.Charts.charts[chart],
                unit = this.data[0].unit;

            window.stackedBarChart(
                this.scope[0],
                {
                    width: info.width,
                    height: info.height,
                    series: this.data,
                    title: I18n.t('establishment_shot.charts.' + this.scope.data('chart')),
                    margin: info.margin,
                    showY: info.showY,
                    showMaxLabel: info.showMaxLabel,
                    max: calculateMax(this.data),
                    mouseover: info.mouseover.bind(this.scope),
                    mouseout: info.mouseout.bind(this.scope),
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
