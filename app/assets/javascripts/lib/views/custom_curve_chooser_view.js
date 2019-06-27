/* globals $ _ App Backbone I18n */
(function(window) {
  'use strict';

  var CustomCurveChooserView;

  /**
   * Creates HTML with the actions which may be taken by a user based on the
   * curve options.
   *
   * @param {object} opts
   *   An object optionally containing the keys showUpload and showRemove
   *   indicating whether those actions should be visible.
   * @param {Function} t
   *   A function which will provide translations.
   *
   * @return {Element | null}
   *   Returns the rendered elements, or null if no options are to be rendered.
   */
  function renderCSVActions(opts, t) {
    var actions = $('<div class="actions" />');
    var actionsList = $('<ul />');

    if (!opts.showUpload && !opts.showRemove) {
      return null;
    }

    if (opts.showUpload) {
      actionsList.append($('<li class="upload"/>').text(t('upload')));
    }

    if (opts.showRemove) {
      actionsList.append($('<li class="remove"/>').text(t('remove')));
    }

    actions.append(actionsList);

    return actions;
  }

  /**
   * Renders the box containing the CSV name and size, and buttons to upload a
   * new curve or revert to default.
   *
   * @param {object} curveData
   *   Information about the curve provided by ETEngine. Requires a name key,
   *   and may optionally provide a date.
   * @param {Function} t
   *   A function which will provide translations.
   * @param {object} opts
   *   Options customising what will be rendered. May contain showUpload,
   *   showRemove, and icon keys.
   *
   * @return {Element}
   */
  function renderCSVInfo(curveData, t, options) {
    var opts = options || {};

    var el = $('<div class="custom-curve" />');
    var main = $('<div class="main" />');
    var details = $('<div class="details" />');

    details.append($('<span class="name" />').text(curveData.name));

    if (curveData.date) {
      details.append(
        $('<span class="date" />').text(
          I18n.strftime(new Date(curveData.date), '%-d %B, %Y')
        )
      );
    }

    main.append($('<div class="file ' + (opts.icon || 'csv') + '" />'));
    main.append(details);

    el.append(main);
    el.append(renderCSVActions(opts, t));

    return el;
  }

  /**
   * Creates HTML for a hidden upload form which may be manipulated by the
   * CustomCurveChooserView.
   *
   * @param {string} action The URL to which the form will be submitted.
   * @return {Element}
   */
  function renderUploadForm(action) {
    var form = $('<form />')
      .attr('action', action)
      .attr('enctype', 'multipart/form-data')
      .attr('method', 'POST')
      .css('display', 'none');

    form.append(
      $('<input />')
        .attr('type', 'file')
        .attr('accept', '.csv,text/csv')
        .attr('name', 'file')
    );

    return form;
  }

  /**
   * Backbone view which shows the CSV information, with options to upload a new
   * curve or revert to the default. Handles loading the curve information from
   * ETEngine when rendered.
   */
  CustomCurveChooserView = Backbone.View.extend({
    events: {
      'click .remove': 'removeCurve',
      'click .upload': 'selectCurve',
      'change form input[type=file]': 'fileDidChange'
    },

    initialize: function() {
      this.curveData = null;

      this.apiURL =
        App.scenario.url_path() + '/custom_curves/imported_electricity_price';

      // Allow this.t to be passed into other functions while retaining scope.
      this.t = _.bind(this.t, this);
    },

    render: function() {
      if (!this.curveData) {
        this.sendRequest('GET');
        this.renderLoading();

        return this;
      }

      this.$el.empty();

      if (this.curveData.name) {
        this.$el.append(
          renderCSVInfo(this.curveData, this.t, {
            showUpload: true,
            showRemove: true
          })
        );
      } else {
        this.$el.append(
          renderCSVInfo({ name: this.t('default') }, this.t, {
            showUpload: true
          })
        );
      }

      // Notify listeners whether a custom curve is present.
      this.trigger('curveIsSet', !!this.curveData.name);

      this.$el.append(renderUploadForm(this.apiURL));

      return this;
    },

    renderLoading: function() {
      this.$el.empty();

      this.$el.append(
        renderCSVInfo({ name: this.t('loading') }, this.t, { icon: 'loading' })
      );
    },

    renderUploading: function() {
      this.$el.empty();

      this.$el.append(
        renderCSVInfo({ name: this.t('uploading') + '...' }, this.t, {
          icon: 'loading'
        })
      );

      this.$('.details').append($('<progress value="0" max="100" />'));
    },

    renderError: function(errors) {
      var errorsList = $('<ul />');

      this.$el.empty();

      if (this.previousCurveData) {
        this.curveData = this.previousCurveData;
        this.render();
      }

      errors.forEach(function(message) {
        errorsList.append($('<li />').text(message));
      });

      this.$el.append($('<div class="errors" />').append(errorsList));
    },

    // Data

    sendRequest: function(method, options) {
      var self = this;

      this.previousCurveData = this.curveData;

      return $.ajax(
        $.extend(
          {},
          {
            url: this.apiURL,
            method: method,
            success: function(data) {
              self.curveData = data;
              self.render();
            },
            error: function(xhr) {
              var errors = ['An error occurred.'];

              if (xhr.responseJSON) {
                if (xhr.responseJSON.error_keys) {
                  errors = xhr.responseJSON.error_keys.map(function(key) {
                    return self.t('errors.' + key);
                  });
                } else if (xhr.responseJSON.errors) {
                  errors = xhr.responseJSON.errors;
                }
              }

              self.renderError(errors);
            }
          },
          options || {}
        )
      );
    },

    /**
     * Returns a translation.
     */
    t: function(id) {
      var defaultKey = 'custom_curves.' + id;

      if (this.options.curveName) {
        return I18n.t('custom_curves.' + this.options.curveName + '.' + id, {
          defaults: [{ scope: defaultKey }]
        });
      }

      return I18n.t(defaultKey);
    },

    // Events

    removeCurve: function() {
      if (confirm(this.t('confirm_remove'))) {
        this.curveData = null;
        this.renderLoading();

        this.sendRequest('DELETE').success(function() {
          App.call_api();
        });
      }
    },

    selectCurve: function() {
      this.$el
        .find('form')
        .find(':file')
        .click();
    },

    fileDidChange: function() {
      var self = this;
      var fileEl = this.$(':file');

      if (!fileEl.val() || !fileEl.val().length) {
        return;
      }

      this.sendRequest('PUT', {
        data: new FormData(this.$('form')[0]),

        cache: false,
        contentType: false,
        processData: false,

        // Custom XMLHttpRequest
        xhr: function() {
          var myXhr = $.ajaxSettings.xhr();
          if (myXhr.upload) {
            // For handling the progress of the upload
            myXhr.upload.addEventListener(
              'progress',
              function(e) {
                if (e.lengthComputable) {
                  self.$('progress').attr({
                    value: e.loaded,
                    max: e.total
                  });
                }
              },
              false
            );
          }
          return myXhr;
        }
      }).success(function() {
        App.call_api();
      });

      this.curveData = null;
      this.renderUploading();
    }
  });

  CustomCurveChooserView.setupWithWrapper = function(wrapper) {
    var disableInputKey = wrapper.data('curve-disable-input');

    var view = new CustomCurveChooserView({
      el: wrapper,
      curveName: wrapper.data('curve-name')
    });

    // If the el data specifies to enable/disable a slider when a custom curve
    // is set, listen to the view events...
    if (disableInputKey) {
      view.on('curveIsSet', function(isSet) {
        App.input_elements.find_by_key(disableInputKey).set('disabled', isSet);
      });
    }

    return view;
  };

  window.CustomCurveChooserView = CustomCurveChooserView;
})(window);
