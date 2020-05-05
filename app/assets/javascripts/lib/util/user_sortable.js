/* globals _ $ App I18n Sortable Quantity */

(function(window) {
  var optionTemplate = _.template(
    '<li data-id="<%= id %>"' +
      '<% if (!isInstalled) { %>' +
      ' class="not-installed"' +
      '<% } %>' +
      '>' +
      '  <%- name %>' +
      '  <span class="fa fa-bars"></span>' +
      '  <% if (capacity) { %>' +
      '    <div class="flexibility-options__capacity">' +
      '      <% if (isInstalled) { %>' +
      '        <%- capacity %> <%- installed %>' +
      '      <% } else { %>' +
      '        <%- notInstalled %>' +
      '      <% } %> ' +
      '    </div>' +
      '  <% } %>' +
      '</li>'
  );

  /**
   * Given an element and a list of sortable options, renders a list element
   * which may be used by Sortable.
   */
  function renderOptions(element, options, capacities, i18nKey) {
    options.forEach(function(optionKey) {
      var capacity = capacities && capacities[optionKey];

      element.append(
        optionTemplate({
          id: optionKey,
          name: I18n.t('output_elements.' + i18nKey + '.' + optionKey),
          isInstalled: capacity == undefined || capacity.value !== 0,
          capacity: capacity && capacity.smartScale().toString(),
          installed: I18n.t('output_elements.flexibility_order.installed'),
          notInstalled: I18n.t(
            'output_elements.flexibility_order.not_installed'
          )
        })
      );
    });
  }

  /**
   * Queries the capacity of each options element and stores it as a Quantity.
   *
   * @return {jQuery.Deferred}
   *   Returns a deferred with an object mapping sortable options to their
   *   installed capacity.
   */
  function fetchCapacities(options) {
    var deferred = $.Deferred();

    var queries = options.map(function(optionKey) {
      return 'user_sortable_' + optionKey + '_capacity';
    });

    var xhr = $.ajax({
      type: 'PUT',
      dataType: 'json',
      data: {
        gqueries: queries
      },
      url: App.scenario.url_path()
    });

    xhr.success(function(data) {
      var capacities = queries.reduce(function(memo, query_key) {
        var query = data.gqueries[query_key];
        var value = new Quantity(query.future, query.unit);
        var key = query_key.replace(/user_sortable_|_capacity/g, '');

        memo[key] = value;

        return memo;
      }, {});

      deferred.resolve(capacities);
    });

    xhr.error(deferred.reject);

    return deferred.promise();
  }

  /**
   * Handles setting up the user-sortable order and triggers fetching and
   * receiving the order from ETEngine.
   */
  var UserSortable = function(element, resourcePath, showCapacities) {
    this.element = $(element);
    this.lastGood = null;
    this.i18nKey = this.resourcePath = resourcePath;
    this.url = App.scenario.url_path() + '/' + resourcePath;
    this.showCapacities = showCapacities;
  };

  /**
   * Renders the user sortable, setting up Sortable and necessary callbacks.
   */
  UserSortable.prototype.render = function() {
    var self = this;
    var sortableEl = this.element.find('.sortable');

    this.element.addClass('loading');

    var xhr = $.ajax({
      url: this.url,
      type: 'GET'
    });

    xhr.success(function(data) {
      var capDeferred;

      if (self.showCapacities) {
        capDeferred = fetchCapacities(data.order);
      } else {
        capDeferred = $.Deferred().resolve(null);
      }

      capDeferred.done(function(capacities) {
        renderOptions(sortableEl, data.order, capacities, self.i18nKey);
        self.element.removeClass('loading');

        Sortable.create(sortableEl[0], {
          ghostClass: 'ghost',
          animation: 150,
          store: {
            get: function() {
              self.lastGood = data.order;
              return data.order;
            },
            set: function(sortable) {
              self.update(sortable);
            }
          }
        });
      });
    });

    /**
     * Receives a sortable instance and triggers an update to ETEngine.
     */
    UserSortable.prototype.update = function(sortable) {
      var self = this;
      var options = sortable.toArray();

      var data = {};
      data[this.resourcePath] = { order: options };

      var xhr = $.ajax({
        url: this.url,
        type: 'PUT',
        data: data
      });

      xhr.success(function() {
        App.call_api();
        self.lastGood = options;
      });

      xhr.error(function() {
        if (self.lastGood) {
          sortable.sort(self.lastGood);
        }
      });
    };
  };

  window.UserSortable = UserSortable;
})(window);
