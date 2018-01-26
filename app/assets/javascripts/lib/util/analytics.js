var Analytics = (function () {
    'use strict';

    function track(obj) {
        if (window.ga) {
            window.ga('send', 'event', obj.scope, obj.type, obj.data);
        }
    }

    Analytics.prototype = {
        chartAdded: function (key) {
            _.memoize(track({
                scope: 'chart',
                type: 'added',
                data: key
            }));
        },

        inputChanged: function (e) {
            track({
                scope: 'input',
                type: 'changed',
                data: e.attributes.key
            });
        }
    }

    function Analytics () { return; }

    return Analytics;
}());
