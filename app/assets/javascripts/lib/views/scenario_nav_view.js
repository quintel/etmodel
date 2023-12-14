/* globals $ Backbone DropdownView I18n */
(function (window) {
  /**
   * Saves an already-saved scenario.
   *
   * @param {string} path The ETModel API path to be called with the save request
   * @param {number} scenarioID The ID of the active ETEngine scenario.
   *
   * @return {Promise} The promise returned by the request.
   */
  function loadSaveScenarioVersionForm(url, scenarioId) {
    var paramSep = url.includes('?') ? '&' : '?';

    $.fancybox.open({
      autoSize: false,
      href: url + paramSep + 'scenario_id=' + scenarioId + '&inline=true',
      type: 'ajax',
      height: 375,
      width: 530,
      padding: 0,
      afterShow: function () {
        // Prepare form for validation and submitting through an AJAX call.
        const form = document.querySelector('form#new_saved_scenario_version');
        const submit = form.querySelector("input[name='commit']");
        const message = form.querySelector("#saved_scenario_version_message");
        const errorWrapper = document.querySelector('#saved_scenario_version_form_flash');

        submit.addEventListener('click', function (event) {
          event.preventDefault();

          const saveScenarioButton = document.querySelector('.save-scenario');

          // In case of success disable the 'Save scenario' button and close the Fancybox
          handleSuccess = function () {
            saveScenarioButton.disabled = true;
            saveScenarioButton.querySelector('.label').classList.remove('show');
            saveScenarioButton.querySelector('.saved').classList.add('show');

            $.fancybox.close();
          }
          handleError = function (msg) {
            $(errorWrapper).html("<div class='inner-alert message'>"+msg+"</div>");
            $(message).focus();
          }

          // Form is validated, submit it and respond accordingly
          $.ajax({
            url: submit.form.action + '?' + $(submit.form).serialize(),
            method: 'POST',
            dataType: 'json',
            success: function () {
              // Server says OK!
              handleSuccess();
            },
            error: function (response) {
              const error = response.responseJSON.error

              // Request failed.
              if (error == 'saved_scenario_version_exists') {
                // The scenario was already saved. Quietly dismiss the error and treat it as success.
                handleSuccess();
              } else {
                // Some other error occurred. Render it.
                handleError(error);
              }
            }
          });
        });
      },
    });
  }

  function loadSaveScenarioForm(event) {
    var url = event.target.href;
    var paramSep = url.includes('?') ? '&' : '?';

    $.fancybox.open({
      autoSize: false,
      href: url + paramSep + 'inline=true',
      type: 'ajax',
      height: 480,
      width: 530,
      padding: 0,
      afterShow: function () {
        var form = document.querySelector('form#new_saved_scenario');
        var titleField = form.querySelector('#saved_scenario_title');
        var wrapperEl = titleField.closest('div.input');

        titleField.focus();
        titleField.select();

        form.addEventListener('submit', function (event) {
          if (titleField.value.trim().length === 0) {
            wrapperEl.classList.add('has-error');
            titleField.focus();

            titleField.addEventListener('keyup', function () {
              wrapperEl.classList.remove('has-error');
            });

            event.preventDefault();

            return;
          }
        });
      },
    });
  }

  function confirmForm(event) {
    var url = event.target.href;
    var paramSep = url.includes('?') ? '&' : '?';

    $.fancybox.open({
      autoSize: false,
      href: url + paramSep + 'inline=true',
      type: 'ajax',
      height: 300,
      width: 530,
      padding: 0,
      afterShow: function () {
        var closeBtn = document.querySelector('#cancel-box');
        closeBtn.addEventListener('click', $.fancybox.close);
      },
    });
  }

  var ScenarioNavView = Backbone.View.extend({
    events: {
      'click .save-scenario': 'showSaveScenarioVersionModal',
      'click .save-scenario-as': 'showSaveAsModal',
      'click .save-scenario-as-inline': 'showSaveAsModal',
      'click .uncouple-scenario': 'showConfirmModal',
      'click .reset-scenario': 'showConfirmModal',
    },

    /**
     * Renders the navigation
     */
    render: function () {
      if (!this.el) {
        return;
      }

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

      this.el.querySelectorAll('a[data-dylink]').forEach(function (element) {
        element.href = element.dataset.dylink
          .replace(/:scenario_id/, model.get('id'))
          .replace(/:etengine/, model.etenginePath());
      });

      new DropdownView({ el: this.el.querySelector('.dropdown') }).render();
      if (this.el.querySelector('#dropdown-coupling')){
        new DropdownView({ el: this.el.querySelector('#dropdown-coupling') }).render();
      }

      return this;
    },

    saveScenario: function () {
      var button = this.el.querySelector('.save-scenario');
      button.disabled = true;

      saveScenario(button.dataset.path, this.model.get('id')).always(function () {
        button.querySelector('.label').classList.remove('show');
        button.querySelector('.saved').classList.add('show');

        window.setTimeout(function () {
          button.disabled = false;
          button.querySelector('.saved').classList.remove('show');
          button.querySelector('.main').classList.add('show');
        }, 3000);
      });
    },

    showSaveScenarioVersionModal: function (event) {
      event && event.preventDefault();

      const url = $(this.el).find('button.save-scenario').data('path');
      const scenarioId = this.model.get('id');

      loadSaveScenarioVersionForm(url, scenarioId);
    },

    showSaveAsModal: function (event) {
      event && event.preventDefault();
      loadSaveScenarioForm(event);
    },

    showConfirmModal: function (event) {
      event && event.preventDefault();
      confirmForm(event);
    },
  });

  window.ScenarioNavView = ScenarioNavView;
})(window);
