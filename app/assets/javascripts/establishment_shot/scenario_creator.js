EstablishmentShot.ScenarioCreator = (function () {
    'use strict';

    return {
        create: function (scope) {
            return $.ajax({
                type: 'POST',
                dataType: 'json',
                url: scope.host,
                data: {
                    scenario: {
                        area_code: scope.area
                    }
                }
            });
        }
    }
}());
