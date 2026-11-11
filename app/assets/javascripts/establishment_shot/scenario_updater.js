EstablishmentShot.ScenarioUpdater = (function () {
    'use strict';

    return {
        updateScenario: function (establishment) {
            return $.ajax({
                type: 'PUT',
                dataType: 'json',
                xhrFields: { withCredentials: true },
                data: {
                    gqueries: establishment.queries
                },
                url: establishment.host + '/' + encodeURIComponent(establishment.scenarioId)
            });
        }
    }
}());
