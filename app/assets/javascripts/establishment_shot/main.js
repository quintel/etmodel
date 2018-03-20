var EstablishmentShot = {};

EstablishmentShot.Main = (function() {
    'use strict';

    function prepare(data) {
        var key,
            quantity,
            query,
            result = data;

        for (key in data.gqueries) {
            query = data.gqueries[key];

            if (Quantity.isSupported(query.unit)) {
                quantity = new Quantity(query.present, query.unit).smartScale();

                result.gqueries[key] = {
                    present: quantity.value,
                    unit: quantity.unit.name
                }
            } else {
                result.gqueries[key] = query;
            }
        }

        return result;
    }

    function finished(data) {
        EstablishmentShot.TextUpdater.update(this, data);
        EstablishmentShot.ChartRenderer.render(this, data);

        this.scope.find('.overview').show();
        $("span.loading").remove();
    }

    function updateScenario(data) {
        EstablishmentShot.ScenarioUpdater
            .updateScenario(this, data.id)
            .done(finished.bind(this))
            .fail(EstablishmentShot.ErrorHandler.display.bind(this));
    }

    function createScenario() {
        EstablishmentShot.ScenarioCreator.create(this)
            .done(updateScenario.bind(this))
            .fail(EstablishmentShot.ErrorHandler.display.bind(this));
    }

    function getQueries() {
        return this.scope.find('span[data-query]').map(function () {
            return $(this).data('query');
        }).toArray();
    }

    Main.prototype = {
        render: function () {
            this.queries = getQueries.call(this)
                .concat(EstablishmentShot.Charts.getQueries());

            createScenario.call(this);
        }
    };

    function Main(scope) {
        this.scope = scope;
        this.data  = $(scope).data();
        this.area  = this.data.area;
        this.host  = this.data.host + '/api/v3/scenarios';
    }

    return Main;
}());
