EstablishmentShot.ScenarioCreator = (function () {
    'use strict';

    return {
        create: function (scope) {
            var rawEndYear = window.location.search.match(/\?end_year=(\d{4})/),
                endYear    = rawEndYear ? rawEndYear[1] : scope.data.defaultYear;

            if (!(endYear >= scope.data.minYear && endYear <= scope.data.maxYear)) {
                throw "endYear is not in range: " + endYear;
            }

            return $.ajax({
                type: 'POST',
                dataType: 'json',
                url: scope.host,
                data: {
                    scenario: {
                        area_code: scope.area,
                        end_year: endYear
                    }
                }
            });
        }
    }
}());
