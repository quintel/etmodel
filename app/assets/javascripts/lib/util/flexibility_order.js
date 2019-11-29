/* globals _ $ App I18n Sortable */

(function(window) {
  var optionTemplate = _.template(
    '<li data-id="<%= id %>">' +
      '  <%- name %>' +
      '  <div class="flexibility-options__capacity"><%- capacity %></div>' +
      '  <span class="fa fa-bars></span>' +
      '</li>'
  );

  /**
   * Given an element and a list of flexibility options, renders a list element
   * which may be used by Sortable.
   */
  function renderOptions(element, options, capacities) {
    options.forEach(function(optionKey) {
      if (capacities[optionKey] > 0) {
        element.append(
          optionTemplate({
            id: optionKey,
            name: I18n.t('output_elements.flexibility_options.' + optionKey),
            capacity: capacities[optionKey].toString()
          })
        );
      }
    });
  }

  /**
   * Queries the capacity of each options element and stores it as
   * a Quantity, on success calls renderOptions
   */
  var setCapacities = function(sortableEl, options) {
    var queries = [],
        capacities = {},
        query,
        key,
        value;

    options.forEach(function(optionKey) {
      queries.push('merit_flexibility_order_' + optionKey + '_capacity');
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
      queries.forEach(function(query_key) {
        query = data.gqueries[query_key];
        value = new Quantity(query.future, query.unit);
        key = query_key.replace(/merit_flexibility_order_|_capacity/g, '');
        capacities[key] = value.smartScale();
      });
      renderOptions(sortableEl, options, capacities);
    });
  }

  /**
   * Handles setting up the user-sortable flexibility order, and triggers
   * fetching and receiving the order from ETEngine.
   */
  var FlexibilityOrder = function(element) {
    this.element = $(element);
    this.lastGood = null;
    this.url = App.scenario.url_path() + '/flexibility_order';
  };

  /**
   * Renders the flexibility order, setting up Sortable and necessary callbacks.
   */
  FlexibilityOrder.prototype.render = function() {
    var self = this;
    var sortableEl = this.element.find('.sortable');

    this.element.addClass('loading');

    var xhr = $.ajax({
      url: this.url,
      type: 'GET'
    });

    xhr.success(function(data) {
      setCapacities(sortableEl, data.order);
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

    /**
     * Receives a sortable instance and triggers an update to ETEngine.
     */
    FlexibilityOrder.prototype.update = function(sortable) {
      var self = this;
      var options = sortable.toArray();

      var xhr = $.ajax({
        url: this.url,
        type: 'PUT',
        data: { flexibility_order: { order: options } }
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

  window.FlexibilityOrder = FlexibilityOrder;
})(window);
