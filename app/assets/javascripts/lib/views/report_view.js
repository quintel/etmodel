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
  var queryRe = /^(?:present|future)\.([a-z0-9_]+)(?:\.|$)/i;

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

      /* eslint-disable no-param-reassign */

      if (isNaN(Number(query.get('future')))) {
        // Not a numeric value.
        memo.present[key] = query.get('present');
        memo.future[key] = query.get('future');

        return memo;
      }

      if (!Quantity.isSupported(unit)) {
        unit = '#';
      }

      memo.present[key] = new Quantity(query.get('present'), unit);
      memo.future[key] = new Quantity(query.get('future'), unit);

      /* eslint-enable no-param-reassign */

      return memo;
    }, { present: {}, future: {} });
  };

  /**
   * Maps the list of user values from ETEngine to slides and sliders in
   * the ETM interface. Omits any slides for which the user has not provided
   * a custom value.
   *
   * @param {object} valsAn
   *   object of input keys and their values, from ETEngine.
   * @param {array} slides
   *   array of slides in the ETM interface, with an array describing the
   *   inputs/sliders which appear.
   *
   * @return {array}
   *   returns an array of { path: array, input_values: array }
   */
  var mapInputsToSlides = function inputValues(vals, slides) {
    var userVals = _.compact(slides.map(function (slide) {
      var userValues = slide.input_elements.map(function (ie) {
        var values = vals[ie.key];
        var fUser;
        var fDefault;

        if (values && values.user !== undefined) {
          fUser = Metric.autoscale_value(values.user, values.unit);
          fDefault = Metric.autoscale_value(values.default, values.unit);

          // Omit any inputs which would not show a significant change.
          // e.g. "2.0% -> 2.0%" is meaningless to the visitor.
          if (fUser !== fDefault) {
            return _.extend(values, ie);
          }
        }

        return null;
      });

      userValues = _.compact(userValues);

      if (!userValues.length) {
        return null;
      }

      return { path: slide.path, user_values: userValues };
    }));

    return userVals;
  };

  var renderLiquid = function renderLiquid(onSuccess, onError) {
    var template = Liquid.parse($('#report-template').html());
    var queryKeys = extractQueries(template.root.nodelist);

    var queriesDef = $.Deferred();
    var slidesDef = $.getJSON('/input_elements/by_slide');

    // In order to fetch the query values during App.call_api, the queries
    // need to be added to the global collection.
    queryKeys.forEach(function (queryKey) {
      window.gqueries.find_or_create_by_key(queryKey);
    });

    App.call_api({}, {
      success: queriesDef.resolve,
      error: queriesDef.reject
    });

    $.when(queriesDef, App.user_values(), slidesDef)
      .then(function (queryVals, inputVals, slides) {
        onSuccess(template.render(
          $.extend(
            queryValues(queryKeys),
            {
              user_values: mapInputsToSlides(inputVals[0], slides[0]),
              settings: {
                area_code: App.settings.get('area_code'),
                end_year: App.settings.get('end_year'),
                merit_order_enabled: App.settings.merit_order_enabled(),
                start_year: App.settings.get('start_year')
              }
            }
           )
        ));
      })
      .fail(function (queryResp) {
        $('#navbar .loading .bar').addClass('done');
        onError(queryResp.responseJSON.errors);
      });
  };

  /**
   * Converts a list of (jQuery) header elements into a tree structure with
   * <h1> elements in the top-most array, <h2> as their children, <h3> as the
   * children to <h2>.
   */
  var headerTree = function (els) {
    var headers = [];
    var curMajor;
    var curMinor;

    els.each(function (i, header) {
      var element = { el: $(header), children: [] };

      if (!curMajor || header.nodeName === 'H1') {
        curMajor = element;
        curMinor = null;
        headers.push(element);
      } else if (!curMinor || header.nodeName === 'H2') {
        curMinor = element;
        curMajor.children.push(element);
      } else if (header.nodeName === 'H3') {
        curMinor.children.push(element);
      }
    });

    return headers;
  };

  /**
   * Given a tree where the top-level is an array of elements in the form
   * { children: [] }, performs a depth-first traversal of the structure,
   * calling the given func on each node.
   *
   * @param {array} nodes
   *        An array of nodes to traverse.
   * @param {function} func
   *        A function to call on each node. The function is yielded each node,
   *        the index of the node among its siblings, and the location of the
   *        node in the tree.
   * @param {array} location
   *        Internal: Current location/depth of traversal.
   *
   * @return {array} Returns the tree.
   */
  var traverseTree = function (nodes, func, location) {
    nodes.forEach(function (node, index) {
      func(node, index, location || []);

      if (node.children) {
        traverseTree(node.children, func, (location || []).concat(index));
      }
    });

    return nodes;
  };

  /**
   * Assigns an ID to each header element in the tree, based on the text
   * content of the header. Uniqueness is not guaranteed.
   */
  var identHeaders = function (headers) {
    return traverseTree(headers, function (header) {
      if (!header.el.attr('id')) {
        header.el.attr(
          'id',
          header.el.text().toLowerCase().trim()
            .replace(/[^a-z0-9-]+/g, '-')
            .replace(/^-/, '')
            .replace(/-$/, '')
        );
      }
    });
  };

  /**
   * For each header, assigns a section number which provides a perma-link to
   * the section.
   */
  var numberHeaders = function (headers) {
    return traverseTree(headers, function (header, index, location) {
      var numbers = location.concat(index).map(function (i) { return i + 1; });

      header.el.prepend(' ').prepend(
        $('<a class="section-number"></a>')
          .text(numbers.join('.'))
          .attr('href', '#' + header.el.attr('id'))
      );
    });
  };

  var tableOfContent = function (tree, depth, maxDepth) {
    var list = $('<ol class="toc" />');
    depth = depth || 1; // eslint-disable-line no-param-reassign

    tree.forEach(function (header) {
      var li = $($('<li/>').append(
        $('<a/>')
          .attr('href', '#' + header.el.attr('id'))
          .text(header.el.text())
      ));

      if ((!maxDepth || (depth < maxDepth)) &&
            header.children && header.children.length) {
        li.append(tableOfContent(header.children, depth + 1, maxDepth));
      }

      list.append(li);
    });

    return list;
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
        var headers = headerTree($('main').find('h1, h2, h3'));

        numberHeaders(identHeaders(headers));

        container.find('.table-of-content').each(function (i, el) {
          var $el = $(el);
          var maxDepth = parseInt($el.data('max-depth'), 10);

          if (isNaN(maxDepth)) {
            maxDepth = null;
          }

          $el.html(tableOfContent(headers, 1, maxDepth));
        });

        self.renderCharts(function () {
          $('#navbar .loading .bar').addClass('done');
        });

        $('#report .loading').remove();
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
    renderCharts: function (cb) {
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
        if (cb) cb();

        // Charts loaded; wait 1 second for the chart transitions.
        window.setTimeout(function () {
          window.status = 'chartsDidLoad';
        }, 1000);
      } });
    }
  });

  /**
   * Actions to take when the initial requests to load ETE data fail. Typically
   * due to the use of a local ETE which hasn't warmed-up.
   */
  ReportView.onLoadingError = function () {
    var loading = $('#report .loading');

    loading.find('h1').html('Sorry&hellip;');

    loading.find('p').html(
      'We weren\'t able to fetch the data in a timely manner.<br/>' +
      'Please try ' +
      '<a href="javascript:location.reload(true)">reloading the page</a>.'
    );

    $('#navbar .loading .bar').addClass('error');
  };

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
      return (
        '<abbr>' +
          Metric.autoscale_value(value, unit) +
        '</abbr>'
      );
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
    tagSyntax: /(\d+)( ?\| .*)?/,

    // Underscore template which renders the necessary elements around the
    // chart.
    template: _.template(
      '<div class="chart<%= showLegend ? "" : " hidden-legend" %>">' +
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

    defaultOpts: { legend: true },

    init: function (tagName, markup, tokens) {
      var parts = markup.match(this.tagSyntax);

      if (parts) {
        this.chartId = parts[1];
        this.opts = _.extend({}, this.defaultOpts, this.parseOpts(parts[2]));
      } else {
        throw new Error('Syntax error in "chart" - Valid syntax: chart key');
      }

      // eslint-disable-next-line no-underscore-dangle
      this._super(tagName, markup, tokens);
    },

    render: function (context) {
      return this.template({
        chartId: this.chartId,
        showLegend: this.opts.legend,
        // eslint-disable-next-line no-underscore-dangle
        caption: this._super(context).join('').trim()
      });
    },

    parseOpts: function (options) {
      var tokens;

      if (!options || !options.trim().length) {
        return {};
      }

      tokens = options.trim().match(/([\w]+): ([\w0-9]+)\b/g);

      return _.reduce(tokens, function (memo, token) {
        var parts = token.replace(/^ ?\| /, '').split(': ');

        if (parts[1] === 'false') {
          parts[1] = false;
        } else if (parts[1] === 'true') {
          parts[1] = true;
        } else if (!isNaN(Number(parts[1]))) {
          parts[1] = Number(parts[1]);
        }

        memo[parts[0]] = parts[1]; // eslint-disable-line no-param-reassign
        return memo;
      }, {});
    }
  }));

  /**
   * Outputs the current date. Useful for report headers.
   */
  Liquid.Template.registerTag('current_date', Liquid.Tag.extend({
    render: function () {
      return new Date().strftime('%d %B, %Y');
    }
  }));

  /**
   * Outputs a link to to the users scenario.
   */
  Liquid.Template.registerTag('link_to_scenario', Liquid.Tag.extend({
    render: function () {
      var path = '/scenarios/' + App.scenario.api_session_id();

      return (
        '<a href="' + window.location.origin + path + '">' +
          window.location.host + path +
        '</a>'
      );
    }
  }));

  Liquid.Template.registerTag('toc', Liquid.Tag.extend({
    init: function (tagName, markup) {
      this.maxDepth = markup;

      // eslint-disable-next-line no-underscore-dangle
      this._super(tagName, markup);
    },

    render: function () {
      var depth;

      if (this.maxDepth) {
        depth = ' data-max-depth="' + this.maxDepth + '"';
      }

      return '<div class="table-of-content"' + depth + '></div>';
    }
  }));

  window.ReportView = ReportView;
}());
