EstablishmentShot.ScenarioCreator = (function () {
    'use strict';

    return {
        create: function (establishment) {
            var data = $(establishment.scope).data();
            var rawEndYear = window.location.search.match(/\?end_year=(\d{4})/),
                endYear    = rawEndYear ? rawEndYear[1] : data.defaultYear;

            if (!(endYear >= data.minYear && endYear <= data.maxYear)) {
                throw "endYear is not in range: " + endYear;
            }

            return $.ajax({
                type: 'POST',
                dataType: 'json',
                url: establishment.host,
                headers: establishment.requestHeaders(),
                data: {
                    scenario: {
                        area_code: establishment.area,
                        end_year: endYear
                    }
                }
            });
        }
    }
}());
