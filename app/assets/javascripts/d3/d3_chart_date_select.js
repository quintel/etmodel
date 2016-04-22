var D3ChartDateSelect = (function () {
    'use strict';

    var epoch = new Date(0),
        msInWeek = 604800000;

    function buildOption(i) {
        var timeFormat = d3.time.format("%b %d"),
            msOffset   = (msInWeek * i),
            start      = new Date(epoch.getDate() + msOffset),
            end        = new Date(start.getDate() + msOffset + msInWeek - (msInWeek / 7));

        this.weeks[i + 1] = [start, end];

        return $("<option/>").attr('value', i + 1).text(
            timeFormat(start) + " - " + timeFormat(end)
        );
    }

    function createOptions() {
        var i;

        this.selectBox.append($('<option value="0">Whole year</option>'));

        for (i = 0; i < 52; i += 1) {
            this.selectBox.append(buildOption.call(this, i));
        }
    }

    D3ChartDateSelect.prototype = {
        selectBox: undefined,
        weeks: [ [epoch, new Date(1970, 11, 30) ] ],
        draw: function (updateChart) {
            this.selectBox = $("<select/>").addClass("d3-chart-date-select");
            this.selectBox.on('change', updateChart || function () { return; });

            createOptions.call(this);

            this.scope.append(this.selectBox);
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
        this.scope = scope;
        this.range = range;
    }

    return D3ChartDateSelect;
}());
