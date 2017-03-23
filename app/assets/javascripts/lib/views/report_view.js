/* globals Liquid Quantity App Metric globals */
(function () {
  /**
   * Determines if ETE errors should be shown to the visitor instead of a simple
   * message.
   */
  var showFullErrors = function showFullErrors() {
    return (
      globals.env === 'development' ||
      globals.env === 'test' ||
      globals.debug_js
    );
  };

  /**
   * Formats individual ETE error messages.
   */
  var formatError = function formatError(message) {
    var split = message.split(' | ');
    var messageEl = $('<li />')
      .append($('<h3 class="summary" />').text(split[0]));

    if (split.length > 1) {
      messageEl.append($('<pre />').html(split[1]));
    }

    return messageEl;
  };

  // ---------------------------------------------------------------------------

  // Matches queries in a string.
  var queryRe = /^(?:present|future)\.([a-z0-9_]+)$/i;

  /**
   * Provided a Liquid.js block node (typically an "if") extracts the queries
   * used to satisfy the condition.
   */
  var queriesFromBlock = function queriesFromBlock(block) {
    var queries = [];

    if (block.left && block.left.match(queryRe)) {
      queries.push(block.left.match(queryRe)[1]);
    }

    if (block.right && block.right.match(queryRe)) {
      queries.push(block.right.match(queryRe)[1]);
    }

    return queries;
  };

  /**
   * Given a Liquid.js nodelist, recursively extracts a list of all queries
   * used.
   *
   * @example
   *   extractQueries(Liquid.parse(string).root.nodelist);
   *   // => ['query_one', 'query_two']
   *
   * @param  {[array]} nodelist Array of nodes in the template.
   * @return {[array]}          Array of queries used.
   */
  var extractQueries = function extractQueries(nodelist) {
    var queries = [];

    nodelist.forEach(function (node) {
      if (node.blocks) {
        node.blocks.forEach(function (block) {
          queries = queries.concat(queriesFromBlock(block));
        });
      } else if (node.name && node.name.match(queryRe)) {
        queries = queries.concat([node.name.match(queryRe)[1]]);
      }

      if (node.nodelist) {
        queries = queries.concat(extractQueries(node.nodelist));
      }
    });

    return _.uniq(queries);
  };

  /**
   * Given a list of query keys, transforms the present and future values from
   * these queries into an object which may be used in a Liquid template.
   *
   * @param  {array} queryKeys An array of query keys.
   * @return {object} An object of the form { present: {}, future: {} }
   */
  var queryValues = function queryValues(queryKeys) {
    return _.reduce(queryKeys, function (memo, key) {
      var query = window.gqueries.with_key(key);
      var unit = query.get('unit');

      if (!Quantity.isSupported(unit)) {
        unit = '#';
      }

      // eslint-disable-next-line no-param-reassign
      memo.present[key] = new Quantity(query.get('present'), unit);
      // eslint-disable-next-line no-param-reassign
      memo.future[key] = new Quantity(query.get('future'), unit);

      return memo;
    }, { present: {}, future: {} });
  };

  var renderLiquid = function renderLiquid(onSuccess, onError) {
    var template = Liquid.parse($('#report-template').html());
    var queryKeys = extractQueries(template.root.nodelist);

    // In order to fetch the query values during App.call_api, the queries
    // need to be added to the global collection.
    queryKeys.forEach(function (queryKey) {
      window.gqueries.find_or_create_by_key(queryKey);
    });

    App.call_api({}, {
      success: function () {
        onSuccess(template.render(
          $.extend(queryValues(queryKeys), { settings: {
            area_code: App.settings.get('area_code'),
            end_year: App.settings.get('end_year'),
            merit_order_enabled: App.settings.merit_order_enabled(),
            start_year: App.settings.get('start_year')
          } })
        ));
      },
      error: function (resp) {
        onError(resp.responseJSON.errors);
      }
    });
  };

  // ---------------------------------------------------------------------------

  /**
   * Takes an array of report component data and recursively renders the
   * components.
   *
   * For example
   *   new ReportView({ components: [{ ... }] });
   */
  var ReportView = Backbone.View.extend({
    className: 'report-view',

    /**
     * Renders the report into the given element, running post-processing
     * methods as necessary to fetch charts and other scenario data. Prefer this
     * over using render() and renderCharts().
     */
    renderInto: function (container) {
      var self = this;

      container.append(this.render(function () {
        self.renderCharts();
      }));
    },

    /**
     * Renders the report. Provide an optional callback function to be invoked
     * once the template text has been parsed and rendered.
     */
    render: function (cb) {
      var self = this;

      renderLiquid(
        // onSuccess
        function (template) {
          self.$el.html(template);
          if (cb) cb(template);
        },
        // onError
        function (errors) {
          self.renderErrors(errors);
          if (cb) cb();
        }
      );

      return this.$el;
    },

    /**
     * In the event of an error during template rendering, shows the errors to
     * the user.
     */
    renderErrors: function (messages) {
      var errors = $('<div class="report-errors"></div>');

      errors.append($('<p />').text(
        'Sorry, your report could not be created.'
      ));

      if (showFullErrors()) {
        errors.append($('<ul />').append(messages.map(formatError)));
      }

      this.$el.empty().append(errors);

      return this.$el;
    },

    /**
     * Post-processing method which looks through the rendered report for a list
     * of charts to be rendered.
     */
    renderCharts: function () {
      var requests = {};

      $(this.$el.find('.chart_inner')).each(function (index, el) {
        var chartEl = $(el);
        var holderId = _.uniqueId('rchart_holder_');
        var chartId = chartEl.data('report-chart-id');

        window.charts.add_container_if_needed(holderId, {
          wrapper: '#' + chartEl.attr('id'),
          header: false
        });

        requests[holderId] = chartId + '-C';
      });

      window.charts.load_charts(requests, { success: function () {
        // Charts loaded; wait 1 second for the chart transitions.
        window.setTimeout(function () {
          window.status = 'chartsDidLoad';
        }, 1000);
      } });
    }
  });

  // ---------------------------------------------------------------------------

  Liquid.Template.registerFilter({
    /**
     * Renders a query value without the unit.
     *
     * @example
     *   "{{ future.query_key | without_unit }}"
     */
    without_unit: function (value) {
      if (value instanceof Quantity) {
        return value.value;
      }

      return value;
    },

    /**
     * Liquid filter which rounds numbers to the desired precision.
     *
     * @example
     *   "{{ future.query_key | round: 2 }}"
     */
    round: function (value, precision) {
      var multiplier = Math.pow(10, precision || 2);

      if (value instanceof Quantity) {
        return new Quantity(
          Math.round(value.value * multiplier) / multiplier,
          value.unit.name
        );
      }

      return Math.round(value * multiplier) / multiplier;
    },

    autoscale: function (value, unit) {
      return Metric.autoscale_value(value, unit);
    }
  });

  /**
   * Liquid component which renders a chart with an optional caption.
   *
   * @example
   *   "{% chart 52 %}{% endchart %}"
   *
   * @example
   *   "{% chart 52 %}This is a caption{% endchart %}"
   */
  Liquid.Template.registerTag('chart', Liquid.Block.extend({
    tagSyntax: /(\d+)/,

    // Underscore template which renders the necessary elements around the
    // chart.
    template: _.template(
      '<div class="chart">' +
      '  <div ' +
      '    class="chart_inner" ' +
      '    id="<%= _.uniqueId("rchart_") %>" ' +
      '  data-report-chart-id="<%= chartId %>" ' +
      '></div> ' +
      '  <% if (caption && caption.length) { %>' +
      '    <div class="caption"><%= caption %></div>' +
      '  <% } %>' +
      '</div>'
    ),

    init: function (tagName, markup, tokens) {
      var parts = markup.match(this.tagSyntax);

      if (parts) {
        this.chartId = parts[1];
      } else {
        throw new Error('Syntax error in "chart" - Valid syntax: chart key');
      }

      // eslint-disable-next-line no-underscore-dangle
      this._super(tagName, markup, tokens);
    },

    render: function (context) {
      return this.template({
        chartId: this.chartId,
        // eslint-disable-next-line no-underscore-dangle
        caption: this._super(context).join('').trim()
      });
    }
  }));

  window.ReportView = ReportView;
}());
