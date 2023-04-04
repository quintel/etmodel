/* globals $ App Backbone I18n */
(function (window) {
    var ScenarioEndYearView = Backbone.View.extend({
      events: {
        'click a': 'onClickItem',
      },

      constructor: function () {
        Backbone.View.apply(this, arguments);

        this.yearList = this.options.yearList;
        this.hideAll = this.options.hideAll;
        this.isFirstElem = this.options.firstElem;
      },

      render: function() {
        if (this.isFirstElem) {
            this.toggle();
        }
      },

      /**
       * Event triggered when the user clicks one of the two tabs.
       *
       * @param {MouseEvent} event
       */
      toggle: function (event) {
        event && event.preventDefault();

        this.el.classList.add('active');
        this.yearList.classList.add('show');
      },


      onClickItem: function () {
        this.hideAll();
        this.toggle();
      },
    });

    var FeaturedScenarioView = Backbone.View.extend({
      events: {
      },

      constructor: function () {
        Backbone.View.apply(this, arguments);

        this.yearLists = this.el.querySelectorAll('.scenario-list');
      },

      render: function () {
        var scenarioList = this.scenarioList.bind(this);
        var hideAll = this.hideAll.bind(this);
        var firstElem = true;

        this.el.querySelectorAll('.year-tabs .end-year-tab').forEach(function (element) {
            new ScenarioEndYearView({
                el: element,
                yearList: scenarioList(element.getAttribute('year')),
                hideAll: hideAll,
                firstElem: firstElem,
            }).render();

            firstElem = false;
        });


      },

      scenarioList: function (end_year) {
        var found;
        this.yearLists.forEach( function (element) {
            if (element.getAttribute('year') == end_year) {
                found = element;
                // how to break when found?
            }
        });
        return found;
      },

      hideAll: function () {
        this.el.querySelectorAll('.year-tabs .end-year-tab').forEach( function (element) {
            element.classList.remove('active');
        });
        this.yearLists.forEach( function (element) {
            element.classList.remove('show');
        });
      },
    });

    $(function () {
      new FeaturedScenarioView({ el: document.querySelector('#preset-scenario') }).render();
    });

    window.ScenarioEndYearView = ScenarioEndYearView;
    window.FeaturedScenarioView = FeaturedScenarioView;
  })(window);
