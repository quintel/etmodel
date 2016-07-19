var D3ChartDateSelect = (function () {
    'use strict';

    var epoch = new Date(0),
        msInWeek = 604800000;

    function buildOption(i) {
        var nextIndex  = (i + 1),
            timeFormat = d3.time.format("%b %d"),
            msOffset   = (msInWeek * i),
            start      = new Date(epoch.getDate() + msOffset),
            end        = new Date(start.getDate() + msOffset + msInWeek),
            optionText = (timeFormat(start) + " - " + timeFormat(end));

        this.weeks[nextIndex] = [start, end];

        return '<option value="' + nextIndex + '">' + optionText + '</option>';
    }

    function createOptions() {
        var i,
            options = '<option value="0">Whole year</option>';

        for (i = 0; i < 52; i += 1) {
            options += buildOption.call(this, i);
        }

        return options;
    }

    function updateMeritChartsDate(s, val) {
        this.selectBox.val(val);
        this.updateChart && this.updateChart();
    }

    function setMeritChartsDate() {
        App.settings.set('merit_charts_date', $(this).val());
    }

    function buildSelectBox() {
        return $("<select/>")
            .addClass("d3-chart-date-select")
            .append(createOptions.call(this))
            .val(App.settings.get('merit_charts_date') || '1')
            .on('change', setMeritChartsDate);
    }

    D3ChartDateSelect.prototype = {
        selectBox: undefined,
        weeks: [ [ epoch, new Date(1970, 11, 30) ] ],
        draw: function (updateChart) {
            this.updateChart = updateChart;
            this.selectBox = buildSelectBox.call(this);

            this.scope.append(this.selectBox);

            App.settings.on('change:merit_charts_date',
                updateMeritChartsDate.bind(this));

        },

        getCurrentRange: function () {
            return this.weeks[this.val()];
        },

        val: function () {
            return parseInt(this.selectBox.val(), 10);
        },

        isWeekly: function () {
            return this.val() > 0;
        }
    };

    function D3ChartDateSelect(scope, range) {
        this.scope = $(scope);
        this.range = range;
    }

    return D3ChartDateSelect;
}());
