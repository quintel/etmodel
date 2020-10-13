/* globals $ Backbone I18n ToastView */
(function(window) {
  /**
   * Saves an already-saved scenario.
   *
   * @param {string} path The ETModel API path to be called with the save request
   * @param {number} scenarioID The ID of the active ETEngine scenario.
   *
   * @return {Promise} The promise returned by the request.
   */
  function saveScenario(path, scenarioID) {
    var request = $.ajax({
      url: path,
      data: { scenario_id: scenarioID },
      dataType: 'json',
      method: 'put'
    });

    request.success(function() {
      ToastView.create('<span class="fa fa-check"></span> ' + I18n.t('toast.scenario_saved'), {
        className: 'success'
      }).start();
    });

    request.error(function() {
      ToastView.destroyAll();
    });

    return request;
  }

  var ScenarioNavView = Backbone.View.extend({
    events: {
      'click .save-scenario': 'saveScenario',
      'click .scenario-actions': 'toggleScenarioActions'
    },

    /**
     * Renders the navigation
     */
    render: function() {
      if (!this.model.get('id')) {
        // If the scenario is being created, leave the "Loading" scenario nav and re-render when
        // data is available.
        this.model.once('change:id', this.render.bind(this));
        return this;
      }

      var attrs = this.model.apiAttributes();

      this.$el
        .find('.region')
        .text(I18n.t('areas.' + attrs.area_code))
        .addClass(attrs.area_code);

      this.$el.find('.year').text(attrs.end_year);
      this.$el.find('button').attr('disabled', false);
      this.$el.find('a.disabled').removeClass('disabled');

      var model = this.model;

      this.el.querySelectorAll('a[data-dylink]').forEach(function(element) {
        element.href = element.dataset.dylink
          .replace(/:scenario_id/, model.get('id'))
          .replace(/:etengine/, model.etenginePath());
      });

      return this;
    },

    saveScenario: function() {
      var button = this.$el.find('.save-scenario');
      var origHTML = button.html();

      button
        .attr('disabled', true)
        .width(button.width())
        .html(I18n.t('scenario_nav.saving') + '&hellip;');

      saveScenario(button.data('path'), this.model.get('id')).always(function() {
        button
          .attr('disabled', false)
          .html(origHTML)
          .width('auto');
      });
    },

    /**
     * Event triggered when the user clicks the "Actions" button.
     *
     * @param {MouseEvent} event
     */
    toggleScenarioActions: function() {
      var target = this.el.querySelector('.scenario-actions');
      var menu = target.closest('.dropdown').querySelector('.dropdown-menu');

      if (menu.classList.contains('show')) {
        menu.classList.remove('show');
        target.classList.remove('active');
        target.ariaExpanded = false;

        document.removeEventListener('click', this.dismissEvent);
        this.dismissEvent = null;
      } else {
        menu.classList.add('show');
        target.classList.add('active');
        target.ariaExpanded = true;

        this.dismissEvent = this.dismissScenarioActions.bind(this);
        document.addEventListener('click', this.dismissEvent);
      }
    },

    /**
     * Event added to the document whenever the scenario actions dropdown is open. If a click occurs
     * outside of the dropdown, the dropdown is closed.
     */
    dismissScenarioActions: function(event) {
      if (!event.target.closest('.dropdown')) {
        this.toggleScenarioActions();
      }
    }
  });

  window.ScenarioNavView = ScenarioNavView;
})(window);
