EstablishmentShot.ScenarioUpdater = (function () {
    'use strict';

    return {
        updateScenario: function (establishment) {
            return $.ajax({
                type: 'PUT',
                dataType: 'json',
                headers: establishment.requestHeaders(),
                data: {
                    gqueries: establishment.queries
                },
                url: establishment.host + '/' + establishment.scenarioId
            });
        }
    }
}());
