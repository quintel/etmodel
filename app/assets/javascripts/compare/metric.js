/* globals $ _ Backbone App I18n */

(function() {
  'use strict';

  // # Constants

  var METRIC_VIEW_T;

  // Queries whose values are to be summarised. Move to DB?
  var METRICS = [
    {
      key: 'total_co2_emissions',
      unit: 'MT',
      lowerBetter: true
    },
    {
      key: 'total_costs',
      unit: 'BLN',
      lowerBetter: true
    },
    {
      key: 'primary_demand_caused_by_final_demand',
      unit: 'PJ',
      lowerBetter: true
    }
  ];

  // Additional queries to fetch for each scenario.
  var ADDITIONAL_QUERIES = ['households_number_of_inhabitants'];

  // Colors assigned to each scenarios.
  var SCENARIO_COLORS = [
    '#6a3d9a',
    '#1f78b4',
    '#33a02c',
    '#b2df8a',
    '#fb9a99',
    '#e31a1c',
    '#a6cee3',
    '#fdbf6f',
    '#ff7f00',
    '#cab2d6',
    '#ffff99',
    '#b15928'
  ];

  // Helpers -------------------------------------------------------------------

  /**
   * Outputs a CSS class which describes whether a value has increased or
   * decreased.
   */
  var changeClassName = function(value) {
    if (value < 0) {
      return 'change-lower';
    } else if (value > 0) {
      return 'change-higher';
    }

    return 'no-change';
  };

  var colorizeBar = function(origVal, newVal) {
    if (newVal / origVal < 0.95) {
      return 'change-lower';
    } else if (newVal / origVal > 1.05) {
      return 'change-higher';
    }

    return 'no-change';
  };

  /**
   * Temporary function to transform the results of queries to more readable
   * units.
   */
  var transformQueries = function(results) {
    var newRes = _.extend({}, results);

    _.keys(results).forEach(function(key) {
      switch (key) {
        case 'total_co2_emissions': // kg to MT
        case 'primary_demand_caused_by_final_demand': // MJ to PJ
        case 'total_costs': // EUR to billion EUR
          newRes[key].present /= 1000000000;
          newRes[key].future /= 1000000000;
          break;
        default:
      }

      newRes[key].present = newRes[key].present;
      newRes[key].future = newRes[key].future;
    });

    return newRes;
  };

  var parseScenarioIDs = function(str) {
    var split = ('' + str)
      .trim()
      .replace(/\s/g, ',')
      .replace(/,+/g, ',')
      .split(',');

    return _.chain(split)
      .map(function(val) {
        return parseInt(val, 10);
      })
      .reject(_.isNaN)
      .uniq()
      .value();
  };

  var areaName = function(areaCode) {
    return I18n.t('areas.' + areaCode);
  };

  // Router --------------------------------------------------------------------

  var Workspace = Backbone.Router.extend({
    routes: {
      'local-global': 'index', // /local-global
      'local-global/:ids': 'show' // /local-global/1,2,3
    },

    /**
     * The index page shows a simple list of available scenarios, with a button
     * to start the comparison. The button is disabled until the visitor has
     * selected one or more scenarios.
     */
    index: function() {
      var selectedCount = 0;

      $('form.select-scenarios').on('change', 'input[type=checkbox]', function(event) {
        var checkboxEl = $(event.target);
        var wrapperEl = checkboxEl.parents('li');

        if (checkboxEl.prop('checked')) {
          wrapperEl.addClass('selected');
          selectedCount += 1;
        } else {
          wrapperEl.removeClass('selected');

          // Prevent sub-zero count during page initialization.
          selectedCount = Math.max(0, selectedCount - 1);
        }

        $('#commit input').attr('disabled', !selectedCount);
      });

      $('#commit input').attr('disabled', true);

      // Run the change handlers in case the visitor pressed their browser back button, in which
      // case some inputs will be checked. Running immediately doesn't seem to work (though it once
      // did) and a short timeout seems to sort the issue.
      window.setTimeout(function() {
        $('form.select-scenarios input[type=checkbox]').change();
      }, 5);

      // Settings menu example for users with no scenarios.
      $('#settings-menu-example').qtip({
        content: {
          text: $('#settings-menu-image')
        },
        position: {
          my: 'right middle',
          at: 'left middle'
        }
      });
    },

    /**
     * Shows a combination-comparison of scenarios.
     */
    show: function(ids) {
      var container = $('#metrics');

      METRIC_VIEW_T = _.template($('#compare-metric-template').html());

      // When IDs are present in the URL, auto-submit.
      if (window.location.pathname.match(/\/local-global\/\d/)) {
        loadComparison(parseScenarioIDs(ids), container);
      }
    }
  });

  // # Models ------------------------------------------------------------------

  var Metric = Backbone.Model.extend({
    /**
     * Returns the sum of all the values for the given gquery and period.
     */
    periodSum: function(period, gquery) {
      return _.reduce(
        this.get('parts'),
        function(memo, part) {
          return memo + part[gquery][period];
        },
        0
      );
    },

    /**
     * Returns the percentage change from the present to the future. For
     * example, a 100 to 50 is a -50 (%) change, while 100 to 200 is a +100 (%)
     * change.
     */
    percentageChange: function(gqueryKey) {
      return (this.future(gqueryKey) / this.present(gqueryKey) - 1) * 100;
    },

    present: function(gqueryKey) {
      return this.periodSum('present', gqueryKey);
    },

    future: function(gqueryKey) {
      return this.periodSum('future', gqueryKey);
    }
  });

  // Views ---------------------------------------------------------------------

  /**
   * Shows the change from the present to the future in all the summarised
   * scenarios.
   */
  var DeltaBar = Backbone.View.extend({
    render: function() {
      // bar width is 85 on each side of 0
      var value = this.options.value;
      var left = 85;
      var width = 0;

      if (value > 0) {
        left = 85;
        width = Math.max(Math.min((value / 100) * 85, 85), 2);
      } else if (value < 0) {
        width = Math.max(Math.min(85 * Math.abs(value / 100), 85), 2);
        left = 85 - width;
      }

      this.$el.append(
        $('<div class="bar" />').append(
          $('<div class="segment" />')
            .css({
              position: 'absolute',
              width: width + 'px',
              left: left + 'px'
            })
            .addClass(changeClassName(value)),
          $('<div class="target" />').css({ left: '50%' })
        )
      );

      return this.$el;
    }
  });

  /**
   * Shows the percentage change between the present and future with a formatted
   * value and a small "delta bar" showing the overall trend.
   */
  var DeltaView = Backbone.View.extend({
    render: function() {
      var percentage = this.model.percentageChange(this.options.key);
      var prefix = percentage < 0 ? '' : '+';
      var arrow = '-';

      if (percentage < 0) {
        arrow = '↓';
      } else if (percentage > 0) {
        arrow = '↑';
      }

      this.$el.append(
        $('<span class="arrow" />')
          .text(arrow)
          .addClass(changeClassName(percentage)),
        ' ',
        prefix,
        Math.round(percentage),
        '%',
        new DeltaBar({ value: percentage }).render()
      );

      return this.$el;
    }
  });

  /**
   * Describes the share of each sub-region in the total for the given data.
   *
   * Options:
   *   data  - An array of values for each sub-region.
   *   width - The inner width of the bar. May be used to reduce the width for
   *           a better comparison with other PeriodBar views.
   *
   * TODO Move "options.data" into a model of some sort
   */
  var PeriodBar = Backbone.View.extend({
    render: function() {
      var total = _.reduce(
        this.options.data,
        function(memo, element) {
          return memo + element.value;
        },
        0.0
      );

      var elements = _.map(this.options.data, function(element) {
        var segment = $('<div class="segment" />').css({
          width: (element.value / total) * 100 + '%'
        });

        segment
          .attr('data-tooltip-title', areaName(element.scenario.areaCode))
          .attr('data-tooltip-text', element.value.toFixed(2) + ' ' + element.unit);

        segment.css('background-color', element.scenario.color);

        return segment;
      });

      this.$el.append(
        $('<div class="bar" />').append(
          $('<div class="inner-bar" />')
            .css({ width: this.options.width })
            .append(elements)
        )
      );

      this.$el.find('.segment').qtip({
        content: {
          title: function() {
            return $(this).attr('data-tooltip-title');
          },
          text: function() {
            return $(this).attr('data-tooltip-text');
          }
        },
        position: {
          target: 'mouse',
          my: 'bottom center',
          at: 'top center'
        }
      });

      return this.$el;
    }
  });

  /**
   * Summarises the values for the future or present. Shows the value and unit
   * with a mini-horizontal stacked-bar.
   */
  var PeriodView = Backbone.View.extend({
    render: function() {
      var period = this.options.period;
      var key = this.options.key;
      var present = this.model.present(key);
      var future = this.model.future(key);
      var value = period === 'future' ? future : present;
      var self = this;

      var barData = _.map(this.model.get('parts'), function(part) {
        return {
          value: part[key][period],
          unit: self.model.get('unit'),
          scenario: part.scenario
        };
      });

      var widest = Math.max(present, future);

      this.$el.append(
        value.toFixed(2),
        $('<span class="unit" />').text(this.model.get('unit')),
        new PeriodBar(
          _.extend(
            {
              data: barData,
              width: (value / widest) * 100 + '%'
            },
            this.barOptions()
          )
        ).render()
      );

      return this.$el;
    },

    /**
     * Creates additional options to be provided to PeriodBar when rendering
     * data for the future.
     */
    barOptions: function() {
      var key;
      var otherData;

      if (this.options.period === 'present') {
        return {};
      }

      key = this.options.key;

      otherData = _.map(this.model.get('parts'), function(part) {
        return { value: part[key].present };
      });

      return { colorize: colorizeBar, otherData: otherData };
    }
  });

  /**
   * Shows an overview of all the loaded scenarios. Shows their legend colours
   * and relative sizes.
   */
  var LegendView = Backbone.View.extend({
    className: 'region-legend',

    formattedMeasure: function(number) {
      if (number > 1000000) {
        return Math.round(number / 100000) / 10 + 'M';
      } else if (number > 10000) {
        return Math.round(number / 1000) + 'k';
      }

      return Math.round(number);
    },

    measureTotal: function() {
      return _.sum(this.options.parts.map(this.extractMeasure));
    },

    extractMeasure: function(part) {
      return part.households_number_of_inhabitants.future;
    },

    render: function() {
      var self = this;
      var total = this.measureTotal();

      var headerText = I18n.t('local_global.legend_header', {
        scenarios: this.options.parts.length
      });

      this.$el.append('<h3>' + headerText + '</h3>');

      this.options.parts.forEach(function(part) {
        var share = part.households_number_of_inhabitants.future / total;
        var inhabitants = self.formattedMeasure(self.extractMeasure(part));

        self.$el.append(
          $('<div class="legend-item" />')
            .css({
              width: share * 100 + '%'
            })
            .append(
              $('<div class="legend-color" />').css({
                'background-color': part.scenario.color
              })
            )
            .append(
              $('<a class="area-code">')
                .text(areaName(part.scenario.areaCode))
                .attr('href', '/scenarios/' + part.scenario.id)
                .attr('title', I18n.t('local_global.view_scenario'))
            )
            .append(
              $('<span class="measure" />').text(
                inhabitants + ' ' + I18n.t('local_global.residents')
              )
            )
        );
      });

      return this.$el;
    }
  });

  /**
   * Shows a breakdown of a metric for a single region.
   */
  var RegionMetricBreakdownView = Backbone.View.extend({
    className: 'region',

    regionModel: function() {
      if (!this.cachedRegionModel) {
        this.cachedRegionModel = new Metric(
          _.extend({}, this.options.model.attributes, {
            parts: [this.options.part]
          })
        );
      }

      return this.cachedRegionModel;
    },

    subViewOpts: function(custom) {
      return _.extend({}, { model: this.regionModel(), key: this.model.get('key') }, custom || {});
    },

    render: function() {
      var deltaView = new DeltaView(this.subViewOpts());
      var presentView = new PeriodView(this.subViewOpts({ period: 'present' }));
      var futureView = new PeriodView(this.subViewOpts({ period: 'future' }));

      this.$el.append(
        $('<div class="title" />').append(
          $('<span class="legend-color" />').css({
            'background-color': this.options.part.scenario.color
          }),
          areaName(this.options.part.scenario.areaCode)
        ),
        $('<div class="delta"></div>').append(deltaView.render()),
        $('<div class="present"></div>').append(presentView.render()),
        $('<div class="future"></div>').append(futureView.render())
      );

      return this.$el;
    }
  });

  /**
   * Shows the contribution of each individual scenario to the metric, showing
   * how each one has changed between the present and future.
   */
  var MetricBreakdownView = Backbone.View.extend({
    className: 'breakdown',

    render: function() {
      var model = this.model;

      var regionEls = this.model.get('parts').map(function(part) {
        return new RegionMetricBreakdownView({
          model: model,
          part: part
        }).render();
      });

      this.$el.append(regionEls);

      return this.$el;
    }
  });

  /**
   * Describes a "metric" for the loaded scenarios: for example, CO2 emissions,
   * total costs, etc. Shows the delta between the present and future, and
   * has sections to break down the present and future contributions from each
   * scenario.
   */
  var MetricView = Backbone.View.extend({
    className: 'metric-view',
    tagName: 'section',

    events: {
      'click h2': 'toggleBreakdown'
    },

    render: function() {
      var key = this.model.get('key');
      var name = I18n.t('local_global.metrics.' + key);

      this.$el.html(METRIC_VIEW_T({ title: name }));

      this.$el.find('.delta').append(new DeltaView({ model: this.model, key: key }).render());

      this.$el.find('.present').append(
        new PeriodView({
          model: this.model,
          key: key,
          period: 'present'
        }).render()
      );

      this.$el.find('.future').append(
        new PeriodView({
          model: this.model,
          key: key,
          period: 'future'
        }).render()
      );

      // Render individual contributions.
      this.$el.append($('<div class="breakdown-container" />'));

      // Add classes to the wrapper.

      if (this.model.get('lowerBetter')) {
        if (this.model.percentageChange(key) > 0) {
          this.$el.addClass('lower-better worse');
        } else {
          this.$el.addClass('lower-better improved');
        }
      } else if (this.model.percentageChange(key) > 0) {
        this.$el.addClass('higher-better improved');
      } else {
        this.$el.addClass('higher-better worse');
      }

      return this.$el;
    },

    toggleBreakdown: function() {
      var container = this.$el.find('.breakdown-container');

      if (this.$el.hasClass('open')) {
        this.$el.removeClass('open');
        return container.empty();
      }

      this.$el.addClass('open');

      container.append(new MetricBreakdownView({ model: this.model }).render());

      return null;
    }
  });

  var DashboardView = Backbone.View.extend({
    className: 'results',

    render: function() {
      var self = this;

      // Legend
      this.$el.append(new LegendView({ parts: this.collection }).render());

      // Header
      this.$el.append(
        $('<section class="header">')
          .append($('<div class="title" />').html('&nbsp;'))
          .append($('<div class="delta" />').html('&nbsp;'))
          .append($('<div class="present" />').text(I18n.t('local_global.present')))
          .append($('<div class="future" />').text(I18n.t('local_global.future')))
      );

      // Dashboard metrics.
      this.options.metrics.forEach(function(metric) {
        var model = new Metric(_.extend(metric, { parts: self.collection }));
        self.$el.append(new MetricView({ model: model }).render());
      });

      return this.$el;
    }
  });

  // Globals -----------------------------------------------------------------

  /**
   * Given an array of scenario IDs and container into which to render the
   * comparison, fetches the scenarios and renders the result.
   */
  function loadComparison(ids, container) {
    var requests = [];
    var errored = [];
    var input = container.find('form.prompt input');

    container.find('.loading').show();
    container.find('form.prompt').hide();
    container.find('.results').remove();
    container.find('form.prompt .errors').remove();

    input.val(ids.join(', '));

    ids.forEach(function(id) {
      var gqueries = _.pluck(METRICS, 'key').concat(ADDITIONAL_QUERIES);

      requests.push(
        $.ajax({
          type: 'PUT',
          url: globals.ete_url + '/api/v3/scenarios/' + id,
          headers: App.accessToken.headers(),
          data: { gqueries: gqueries },
          dataType: 'json'
        }).fail(function(response) {
          errored.push({ id: id, message: response.responseJSON.errors[0] });
        })
      );
    });

    $.when
      .apply($, requests)
      .done(function() {
        var results;
        var data;

        if (ids.length === 1) {
          // If only one scenario is requested, the arguments takes the form of
          // a jQuery XHR callback (JSON, status, XHRObj) instead of an
          // array of each response.
          results = [Array.prototype.slice.call(arguments)];
        } else {
          results = Array.prototype.slice.call(arguments);
        }

        data = _.map(results, function(res, index) {
          // res[0] = scenario JSON; res[1] = response status; res[2] = XHR

          var scenario = {
            areaCode: res[0].scenario.area_code,
            endYear: res[0].scenario.end_year,
            id: res[0].scenario.id,
            startYear: res[0].scenario.end_year,
            color: SCENARIO_COLORS[index % SCENARIO_COLORS.length]
          };

          return _.extend(
            { key: res[0].scenario.id, scenario: scenario },
            transformQueries(res[0].gqueries)
          );
        });

        container.find('.loading').hide();

        container.prepend(
          new DashboardView({
            collection: data,
            metrics: METRICS
          }).render()
        );

        container.find('form.prompt').show();
      })
      .fail(function() {
        // Wait a little bit longer for any other errors to arrive.
        window.setTimeout(function() {
          var messages = errored.map(function(error) {
            return $('<li />').text(error.id + ': ' + error.message);
          });

          container
            .find('form.prompt')
            .append(
              $('<div class="errors" />').append('<h4>Oops!</h4>', $('<ul />').append(messages))
            );

          container.find('.loading').hide();
          container.find('form.prompt').show();
        }, 500);
      });
  }

  $(function() {
    new Workspace(); // eslint-disable-line no-new
    if (!Backbone.History.started) {
      Backbone.history.start({ pushState: true });
    }
  });
})();
