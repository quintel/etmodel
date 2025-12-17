/* globals $ App Backbone I18n */

/**
 * Creates HTML with the actions which may be taken by a user based on the
 * curve options.
 *
 * @param {object} opts
 *   An object optionally containing the keys showUpload and showRemove
 *   indicating whether those actions should be visible.
 * @param {Function} t
 *   A function which will provide translations.
 * @param {array} userScenarios
 *   An array containing objects that represent the users saved scenarios. Is
 *   empty when a user is not logged in or has no scenarios.
 *
 * @return {Element | null}
 *   Returns the rendered elements, or null if no options are to be rendered.
 */
export function renderCSVActions(opts, t, userScenarios) {
  var actions = $('<div class="actions" />');
  var actionsList = $('<ul />');

  if (!opts.showUpload && !opts.showRemove) {
    return;
  }

  if (opts.showUpload) {
    actionsList.append(
      $('<li class="upload" />').append($('<button class="trigger" />').text(t('upload')))
    );
  }

  if (opts.showRemove) {
    actionsList.append(
      $('<li class="remove" />').append($('<button class="trigger" />').text(t('remove')))
    );
  }

  actions.append(actionsList);

  if (userScenarios.length > 0) {
    actions.append(renderSelectScenario(t, userScenarios));
  }

  return actions;
}

/**
 * Renders the selection form for when a user wants to import the price curve
 * from one of their other scenarios.
 *
 * @param {Function} t
 *   A function which will provide translations.
 * @param {array} userScenarios
 *   An array containing objects that represent the users saved scenarios
 *
 * @return {Element}
 *   Returns the rendered elements.
 */
function renderSelectScenario(t, userScenarios) {
  var useScenario = $('<div class="scenario"/>');
  var select = $('<select />');
  select.append('<option value="">' + t('select_scenario') + '</option>');

  userScenarios.forEach(function (scenario) {
    $('<option/>', {
      value: scenario.scenario_id,
      text: scenario.title + ', ' + t('areas.' + scenario.area_code) + ' ' + scenario.end_year,
      data: {
        source_saved_scenario_id: scenario.id,
        source_dataset_key: scenario.area_code,
        source_scenario_title: scenario.title,
        source_end_year: scenario.end_year,
      },
    }).appendTo(select);
  });

  useScenario.append($('<label>' + t('upload_from_scenario') + '</label>'));
  useScenario.append(select);
  useScenario.append($('<button class="use-scenario"/>').text(t('use')));

  return useScenario;
}

/**
 * Formats information about the curve such as the minimum, maximum, and mean.
 *
 * @param {object} stats
 *   Curve stats returned by ETEngine.
 * @param {function} t
 *   Translation function.
 *
 * @return {Element | null}
 *   Returns the rendered elements, or null if no options are to be rendered.
 */
export function formatCurveStats(stats, t) {
  var info = $('<dl />');

  if (!stats) {
    return;
  }

  if (stats.mean != undefined) {
    info.append('<dt>' + t('mean') + '</dt>');
    info.append('<dd>' + formatValue(stats.mean, t) + '</dd>');
  }

  if (stats.min_at != undefined) {
    info.append('<dt>' + t('min') + '</dt>');

    if (stats.min != undefined) {
      info.append('<dd>' + formatTemporalValue(stats.min, stats.min_at, t) + '</dd>');
    } else {
      info.append('<dd>' + formatTimeWithIndex(stats.min_at) + '</dd>');
    }
  }

  if (stats.max_at != undefined) {
    info.append('<dt>' + t('max') + '</dt>');

    if (stats.max != undefined) {
      info.append('<dd>' + formatTemporalValue(stats.max, stats.max_at, t) + '</dd>');
    } else {
      info.append('<dd>' + formatTimeWithIndex(stats.max_at) + '</dd>');
    }
  }

  if (stats.full_load_hours != undefined) {
    info.append('<dt>' + t('full_load_hours') + '</dt>');
    info.append('<dd>' + Math.round(Number.parseFloat(stats.full_load_hours)) + '</dd>');
  }

  return info;
}

function formatCurveScenarioInfo(scenario, t) {
  var info = $('<dl />');
  info.append('<dt>' + t('imported_from') + '</dt>');
  info.append(
    '<dd>' +
      scenario.source_scenario_title +
      '<br/>' +
      t('areas.' + scenario.source_dataset_key) +
      ' ' +
      scenario.source_end_year +
      '</dd>'
  );

  return info;
}

/**
 * Creates a button which can be used to download a custom curve.
 */
function renderDownloadCSVButton(url, t) {
  const downloadCSV = $('<div class="download-file" />').append(
    $('<a>')
      .text(t('download_file'))
      .attr('href', url + '.csv')
  );

  return downloadCSV;
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
export function renderCSVInfo(curveData, userScenarios, t, options) {
  var opts = options || {};

  var el = $('<div class="custom-curve" />');
  var main = $('<div class="main" />');
  var details = $('<div class="details" />');

  var name = curveData.name;
  if (options.isFromScenario) {
    name = t('curve_from_scenario');
  }

  details.append($('<span class="name" />').text(name));
  details.append(
    t
      ? $('<span class="type" />').append(
          $('<button class="trigger-help" />')
            .text(t('type'))
            .append($('<span class="fa fa-question-circle" />'))
        )
      : undefined
  );

  main.append($('<div class="file ' + (opts.icon || 'csv') + '" />'));
  main.append(details);

  el.append(main);

  if (options.help) {
    el.append($('<div class="help" />').append($('<div class="inner" />').text(options.help)));
  }

  if (options.isFromScenario) {
    el.append(formatCurveScenarioInfo(curveData.source_scenario, t));
  }

  el.append(formatCurveStats(curveData.stats, t));

  if (curveData.attached) {
    el.append(renderDownloadCSVButton(options.apiURL, t));
  }

  el.append(renderCSVActions(opts, t, userScenarios));

  return el;
}

/**
 * Formats a single value from the curve.
 *
 * @param {number} value The value to be formatted
 * @param {function} t   Translation function.
 *
 * @return {string}
 */
function formatValue(value, t) {
  return t('value', { value: Math.round(value * 100) / 100 });
}

/**
 * Formats a single value from the curve, including the date on which the
 * value occurs.
 *
 * @param {number} value The value to be formatted
 * @param {number} at    The index in which the value occurs.
 * @param {function} t   Translation function.
 *
 * @return {string}
 */
function formatTemporalValue(value, at, t) {
  return formatValue(value, t) + ' ' + t('on_date', { date: formatTimeWithIndex(at) });
}

/**
 * Converts an index on which an event occurs to a nicely localized time.
 *
 * @param {number} at    The index in which the value occurs.
 *
 * @return {string}
 */
function formatTimeWithIndex(time) {
  var msInHour = 1000 * 60 * 60;

  // new Date() starts at 1AM; subtract an hour to start at midnight.
  var date = new Date(-msInHour + time * msInHour);

  return I18n.strftime(date, '%-d %B');
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
    $('<input />').attr('type', 'file').attr('accept', '.csv,text/csv').attr('name', 'file')
  );

  return form;
}

/**
 * Shown when data about a curve is currently loading.
 */
class CustomCurveLoadingView extends Backbone.View {
  render() {
    this.$el.empty();

    this.$el.append(
      renderCSVInfo({ name: I18n.t('custom_curves.loading') }, undefined, undefined, {
        icon: 'loading',
      })
    );
  }
}

/**
 * Backbone view which shows the CSV information, with options to upload a new
 * curve or revert to the default. Handles loading the curve information from
 * ETEngine when rendered.
 */
class CustomCurveChooserView extends Backbone.View {
  get events() {
    return {
      'click .remove .trigger': 'removeCurve',
      'click .upload .trigger': 'selectCurve',
      'click .trigger-help': 'showHideHelp',
      'click .use-scenario': 'useScenarioCurve',
      'change form input[type=file]': 'fileDidChange',
    };
  }

  static setupWithWrapper(wrapper, collectionDef, userScenarios) {
    new CustomCurveLoadingView({ el: wrapper }).render();

    $.when(collectionDef, userScenarios).done(function (collection, scenarios) {
      var curve = collection.getOrBuild(wrapper.data('curve-name'));

      if (curve.get('internal')) {
        console.error('Internal curves cannot be customized in ETModel: ' + curve.get('key'));
        wrapper.remove();
        return;
      }

      var view = new CustomCurveChooserView({
        el: wrapper,
        model: curve,
        scenarios: scenarios,
      });

      view.render();
    });
  }

  constructor(options) {
    super(options);

    this.userScenarios = this.options.scenarios;
    this.showHelp = !!this.options.showHelp;
    this.apiURL = App.scenario.url_path() + '/custom_curves/' + options.model.get('key');
  }

  render() {
    this.$el.empty();

    if (this.model.isAttached()) {
      this.$el.append(
        renderCSVInfo(this.model.attributes, this.userScenarios, this.t, {
          showUpload: true,
          showRemove: true,
          isFromScenario: this.model.isFromScenario(),
          help: this.t('help', { defaults: [{ message: false }] }),
          apiURL: this.apiURL,
        })
      );
    } else {
      this.$el.append(
        renderCSVInfo({ name: this.t('default') }, this.userScenarios, this.t, {
          showUpload: true,
          icon: 'csv-light',
          help: this.t('help', { defaults: [{ message: false }] }),
          apiURL: this.apiURL,
        })
      );
    }

    this.model.refreshInputState();

    this.$el.append(renderUploadForm(this.apiURL));

    // Show or hide the help box depending on state.
    this.$el.find('.help').toggle(this.showHelp);

    return this.el;
  }

  renderLoading() {
    this.$el.empty();

    this.$el.append(
      renderCSVInfo({ name: this.t('loading') }, undefined, this.t, { icon: 'loading' })
    );
  }

  renderUploading() {
    this.$el.empty();

    this.$el.append(
      renderCSVInfo({ name: this.t('uploading') + '...' }, undefined, this.t, {
        icon: 'loading',
        help: this.t('help', { defaults: [{ message: false }] }),
      })
    );

    this.$el.find('.details .name').append($('<span class="progress" />').text('0%'));
    this.$el.find('.help').toggle(this.showHelp);
  }

  renderError(errors) {
    var errorsList = $('<ul />');

    this.$el.empty();

    this.render();

    errors.forEach(function (message) {
      errorsList.append($('<li />').text(message));
    });

    this.$el.append($('<div class="errors" />').append(errorsList));
  }

  // Data

  sendRequest(method, options) {
    var self = this;

    return $.ajax(
      $.extend(
        {},
        {
          url: this.apiURL,
          method: method,
          headers: App.accessToken.headers(),
          success: function (data) {
            if (data == undefined) {
              // Curve was unattached.
              self.model.purge();
            } else {
              self.model.set(data);
            }

            self.render();
          },
          error: function (xhr) {
            var errors = ['An error occurred.'];

            if (xhr.responseJSON) {
              if (xhr.responseJSON.error_keys) {
                errors = xhr.responseJSON.error_keys.map(function (key) {
                  return self.t('errors.' + key);
                });
              } else if (xhr.responseJSON.errors) {
                errors = xhr.responseJSON.errors;
              }
            }

            self.renderError(errors);
          },
        },
        options || {}
      )
    );
  }

  showHideHelp(event) {
    event.preventDefault();

    this.showHelp = !this.showHelp;
    this.$el.find('.help').slideToggle(150);
  }

  /**
   * Returns a translation.
   */
  t = (id, data) => {
    var defaultKey = 'custom_curves.' + id;
    var defaultScope = [{ scope: defaultKey }];

    if (id.slice(0, 5) === 'areas') {
      return I18n.t(id);
    }

    if (this.model.get('type')) {
      if (data && data.defaults) {
        defaultScope = defaultScope.concat(data.defaults);
      }

      return I18n.t(
        'custom_curves.types.' + this.model.get('type') + '.' + id,
        $.extend({}, data, {
          defaults: defaultScope,
        })
      );
    }

    return I18n.t(defaultKey);
  };

  // Events

  removeCurve() {
    if (confirm(this.t('confirm_remove'))) {
      this.curveData = undefined;
      this.renderLoading();

      this.sendRequest('DELETE').success(function () {
        App.call_api();
      });
    }
  }

  selectCurve() {
    this.$el.find('form').find(':file').click();
  }

  useScenarioCurve() {
    var self = this;
    var selected = this.$('select option:selected')[0];
    var scenarioID = selected.value;

    if (scenarioID == '') {
      return;
    }

    var metadata = $(selected).data();

    this.renderUploading();

    // Fetch curve as string from other scenario (currently wrapped in json)
    var scenarioApiURL = App.api.path(
      'scenarios/' + scenarioID + '/curves/electricity_price.json'
    );

    var req = $.ajax({
      url: scenarioApiURL,
      method: 'GET',
      headers: App.accessToken.headers(),
    });

    // Upload for current scenario
    req.success(function (data) {
      var formData = new FormData();

      formData.append('file', new Blob([data.curve]), scenarioID + '.csv');
      formData.append('metadata[source_scenario_id]', scenarioID);
      for (var key in metadata) {
        formData.append('metadata[' + key + ']', metadata[key]);
      }
      self.upload(formData);
    });
  }

  fileDidChange() {
    var fileEl = this.$(':file');

    if (!fileEl.val() || fileEl.val().length === 0) {
      return;
    }

    this.upload(new FormData(this.$('form')[0]));
  }

  upload(data) {
    var self = this;

    this.sendRequest('PUT', {
      data: data,
      headers: App.accessToken.headers(),
      cache: false,
      contentType: false,
      processData: false,

      // Custom XMLHttpRequest
      xhr: function () {
        var myXhr = $.ajaxSettings.xhr();

        if (myXhr.upload) {
          // For handling the progress of the upload
          myXhr.upload.addEventListener(
            'progress',
            function (e) {
              if (e.lengthComputable) {
                self.$el
                  .find('.details .progress')
                  .text(`${Math.round((e.loaded / e.total) * 100)}%`);
              }
            },
            false
          );
        }

        return myXhr;
      },
    }).success(function () {
      App.call_api();
    });

    this.curveData = undefined;
    this.renderUploading();
  }
}

export default CustomCurveChooserView;
