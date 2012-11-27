(function (window) {
  'use strict';

  /**
   * DashboardChangerView intercepts clicks on +el+ (the "change" button on
   * the right of the dashboard) and shows the user a pop-up which allows them
   * to change the constraints shown on the dash.
   *
   * Not a Backbone view since we don't benefit from using a full view.
   */
  function DashboardChangerView(triggerEl) {
    _.bindAll(this, 'initEvents', 'cancel', 'commit',
                    'onDone', 'onError', 'onAlways');

    $(triggerEl).fancybox({
      href:      '/settings/dashboard',
      type:      'ajax',
      afterShow: this.initEvents,
      closeBtn:  false,
      padding:   0
    });
  }

  /**
   * After FancyBox renders the "change dashboard" form, adds events so that
   * we may intercept submission of the form.
   */
  DashboardChangerView.prototype.initEvents = function () {
    this.el = $('#dashboard-changer')
      .delegate('form',          'submit', this.commit)
      .delegate('button.save',   'click',  this.commit)
      .delegate('button.cancel', 'click',  this.cancel);
  };

  /**
   * Saves the changes made by the user, and fades out the "Save" and "Cancel"
   * buttons.
   */
  DashboardChangerView.prototype.commit = function (event) {
    var formEl    = this.el.find('form'),
      inputEls    = this.el.find('input[name^=dash]:checked'),
      inputsLen   = inputEls.length,
      data        = { dash: {} },
      name,
      input,
      i;

    this.isSending = true;

    for (i = 0; i < inputsLen; i++) {
      input = $(inputEls[i]);
      name  = input.attr('name').replace(/^dash\[([\w\d_]+)\]$/, '$1');

      // Remove the extra stuff from the name so that we are left with
      // only the name of the dashboard group. e.g. dash[costs] => costs
      data.dash[name] = input.val();
    }

    // HTTP method override, auth token, etc.
    data._method            = $('[name=_method]', formEl).val();
    data.authenticity_token = $('[name=authenticity_token]', formEl).val();
    data.utf8               = $('[name=utf8]', formEl).val();

    $.ajax({
      url:       formEl.attr('action'),
      type:     'POST',
      data:      data,
      dataType: 'json'
    }).done(this.onDone)
      .error(this.onError)
      .always(this.onAlways);

    this.el.find('.commit button').animate({ opacity: 0.4 });
    this.el.find('input[name^=dash]:not(:checked)').attr('disabled', true);

    // The ajax indicator is shown after a short delay; this way it doesn't
    // begin fading in, only for the request to complete very quickly, and
    // the user wonder what suddenly popped up. This way it only appears if
    // the request seems to be lagging a bit.
    window.setTimeout(_.bind(function () {
      if (this.isSending) {
        this.el.find('.commit .indicator').fadeIn('slow');
      }
    }, this), 500);

    // The commit function may be used as a callback for a DOM event.
    if (event) { event.preventDefault(); }
  };

  /**
   * Discards any changes made by the user and hides the overlay.
   */
  DashboardChangerView.prototype.cancel = function (event) {
    $.fancybox.close();

    // The cancel function may be used as a callback for a DOM event.
    if (event) { event.preventDefault(); }
  };

  // #### XHR Callbacks

  /**
   * Called upon successful completion of the XHR request.
   */
  DashboardChangerView.prototype.onDone = function (data, status, jqXHR) {
    var constraintsEl  = $('#dashboard');

    $.fancybox.close();

    // Get rid of the existing constraint elements.
    constraintsEl.find('.constraint').remove();
    constraintsEl.prepend(data.html);

    window.dashboard.reset(data.constraints);

    window.dashboard.each(function (constraint) {
      constraint.update_values();
    });

    App.call_api();
  };

  /**
   * Called if an error occurred during the XHR request.
   */
  DashboardChangerView.prototype.onError = function (jqXHR, status, error) {
    this.el
      .find('input[name^=dash]:not(:checked)').attr('disabled', false).end()
      .find('.commit button').animate({ opacity: 1.0 }, 'fast').end()
      .find('.commit .indicator').fadeOut('fast');
  };

  /**
   * Called after an XHR request completed, both when it was successful and
   * when it failed.
   */
  DashboardChangerView.prototype.onAlways = function () {
    this.isSending = false;
  };

  // # Globals ---------------------------------------------------------------

  window.DashboardChangerView = DashboardChangerView;

})(window);
