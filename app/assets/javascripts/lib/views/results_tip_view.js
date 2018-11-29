(function() {
  var closeButton = _.template(
    '<li>' +
      '<button class="<%= cssClass %>">' +
        '<% if (showIcon) { %>' +
          '<span class="fa fa-times"></span> ' +
        '<% } %>' +
        '<%- message %>' +
      '</button>' +
    '</li>'
  );

  var ResultsTipView = Backbone.View.extend({
    id: 'results-tip',

    events: {
      'click .controls .close':         'close',
      'click .controls .close-forever': 'closeForever',
    },

    render: function() {
      this.$el
        .append(this.t('message'))
        .append(this.renderControls());

      return this.$el;
    },

    /**
     * Returns an Element containing the "close" controls for the ResultsTip.
     */
    renderControls: function() {
      var controls = $('<ol/>').addClass('controls');

      controls.append(closeButton({
        cssClass: 'close',
        message: this.t('hide'),
        showIcon: true
      }));

      controls.append(closeButton({
        cssClass: 'close-forever',
        message: this.t('hide_forever'),
        showIcon: false
      }));

      return controls;
    },

    /**
     * Closes the tip. If the browser supports local storage, prevent the tip
     * from being shown again for this scenario.
     */
    close: function(event, scenarioID) {
      event && event.preventDefault();

      $.ajax({
        dataType: 'json',
        url: '/settings/hide_results_tip',
        method: 'PUT',
        data: { scenario_id: this.scenarioID(scenarioID) }
      });

      this.$el.fadeOut()
    },

    /**
     * Determines the scenario. Uses the given ID, if present, otherwise falls
     * back to using the getScenarioID option.
     */
    scenarioID: function(id) {
      return id ||
        (this.options.getScenarioID && this.options.getScenarioID()) ||
        'all';
    },

    closeForever: function(event) {
      this.close(event, 'all');
    },

    /**
     * Returns a translated string.
     */
    t: function (key) {
      return I18n.t('results_tip.' + key)
    },
  });

  /**
   * Returns if the results tip view should be shown to the user. If the user
   * has previously dismissed the tip, it will not be shown again.
   */
  ResultsTipView.shouldShow = function () {
    return window.globals.show_results_tip;
  }

  window.ResultsTipView = ResultsTipView;
})(window);
