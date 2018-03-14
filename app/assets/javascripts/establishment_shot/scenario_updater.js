EstablishmentShot.ScenarioUpdater = (function () {
    'use strict';

    return {
        updateScenario: function (scope, scenarioId) {
            return $.ajax({
                type: 'PUT',
                dataType: 'json',
                data: {
                    gqueries: scope.queries
                },
                url: scope.host + '/' + scenarioId
            });
        }
    }
}());
