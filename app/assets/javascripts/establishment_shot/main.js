var EstablishmentShot = {
  scenarioId: false,
  host: false,
  area: false,
  queries: false,
};

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
    var scope = EstablishmentShot.scope;
    EstablishmentShot.TextUpdater.update(scope, data, EstablishmentShot.time);
    EstablishmentShot.ChartRenderer.render(scope, data, EstablishmentShot.time);

    scope.find('.overview').show();
    $('a.scenario-link').attr('href', '/scenarios/' + EstablishmentShot.scenarioId + '/load');
    $('span.loading').remove();
  }

  function renderWithScenario() {
    EstablishmentShot.ScenarioUpdater.updateScenario(EstablishmentShot)
      .done(finished)
      .fail(EstablishmentShot.ErrorHandler.display.bind(EstablishmentShot));
  }

  function renderWithoutScenario() {
    EstablishmentShot.ScenarioCreator.create(EstablishmentShot)
      .done(function(data){
        EstablishmentShot.scenarioId = data.id;
        renderWithScenario();
      })
      .fail(EstablishmentShot.ErrorHandler.display.bind(EstablishmentShot));
  }

  function getQueries() {
    return EstablishmentShot.scope.find('span[data-query]').map(function () {
      return $(this).data('query');
    }).toArray();
  }

  Main.prototype = {
    render: function () {
      EstablishmentShot.Charts.setNonEnergy(EstablishmentShot.nonEnergy);
      EstablishmentShot.queries = getQueries()
        .concat(EstablishmentShot.Charts.getQueries());

      if (EstablishmentShot.scenarioId) {
        renderWithScenario();
      } else {
        renderWithoutScenario();
      }

    }
  };

  function Main(scope) {
    var data = $(scope).data();
    EstablishmentShot.scope = scope;
    EstablishmentShot.host = data.host + '/api/v3/scenarios';
    EstablishmentShot.area = data.area;
    EstablishmentShot.scenarioId = data.scenarioId;
    EstablishmentShot.time = data.time;
    EstablishmentShot.nonEnergy = data.nonEnergy == "on";
    console.log(data)
  }

  return Main;
}());
