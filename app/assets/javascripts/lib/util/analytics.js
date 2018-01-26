var Analytics = (function () {
    'use strict';

    function track(obj) {
        if (window.ga) {
            window.ga('send', obj.event, obj.type, obj.data);
        }
    }

    Analytics.prototype = {
        chartAdded: function (key) {
            track({
                event: 'event',
                type: 'chart-add',
                data: key
            });
        },

        changeInput: function (e) {
            track({
                event: 'event',
                type: 'input-change',
                data: e.attributes.key
            });
        }
    }

    function Analytics () { return; }

    return Analytics;
}());
