/* globals _ $ App I18n Sortable */

(function(window) {
  var optionTemplate = _.template(
    '<li data-id="<%= id %>">' +
      '  <%- name %>' +
      '  <span><%- capacity %></span>' +
      '  <span class="fa fa-bars></span>' +
      '</li>'
  );

  /**
   * Given an element and a list of flexibility options, renders a list element
   * which may be used by Sortable.
   */
  function renderOptions(element, options) {
    options.forEach(function(optionKey) {
      element.append(
        optionTemplate({
          id: optionKey,
          name: I18n.t('output_elements.flexibility_options.' + optionKey),
          capacity: '10 MW'
        })
      );
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

    // this request should be expanded to also include the capacities
    // or should there be a new request?
    var xhr = $.ajax({
      url: this.url,
      type: 'GET'
    });

    xhr.success(function(data) {
      renderOptions(sortableEl, data.order);
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
