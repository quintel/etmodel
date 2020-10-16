/* globals $ Backbone DropdownView I18n ToastView */
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

  function loadSaveScenarioForm(event) {
    $.fancybox.open({
      autoSize: false,
      href: event.target.href + '?inline=true',
      type: 'ajax',
      height: 480,
      width: 530,
      padding: 0,
      afterShow: function() {
        var form = document.querySelector('form#new_saved_scenario');
        var titleField = form.querySelector('#saved_scenario_title');
        var wrapperEl = titleField.closest('div.input');

        titleField.focus();

        form.addEventListener('submit', function(event) {
          if (titleField.value.trim().length === 0) {
            wrapperEl.classList.add('has-error');
            titleField.focus();

            titleField.addEventListener('keyup', function() {
              wrapperEl.classList.remove('has-error');
            });

            event.preventDefault();

            return;
          }
        });
      }
    });
  }

  var ScenarioNavView = Backbone.View.extend({
    events: {
      'click .save-scenario': 'saveScenario',
      'click .save-scenario-as': 'showSaveAsModal',
      'click .save-scenario-as-inline': 'showSaveAsModal'
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
        .addClass(this.model.countryCode());

      this.$el.find('.year').text(attrs.end_year);
      this.$el.find('button').attr('disabled', false);
      this.$el.find('a.disabled').removeClass('disabled');

      var model = this.model;

      this.el.querySelectorAll('a[data-dylink]').forEach(function(element) {
        element.href = element.dataset.dylink
          .replace(/:scenario_id/, model.get('id'))
          .replace(/:etengine/, model.etenginePath());
      });

      new DropdownView({ el: this.el.querySelector('.dropdown') }).render();

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

    showSaveAsModal: function(event) {
      event && event.preventDefault();
      loadSaveScenarioForm(event);
    }
  });

  window.ScenarioNavView = ScenarioNavView;
})(window);
