(function (window) {
  'use strict';

  var DASHBOARD_CHANGER_T, DashboardChangerView;

  // # Constants -------------------------------------------------------------

  $(function () {
    DASHBOARD_CHANGER_T = _.template(
      $('#dashboard-changer-template').html() || '');
  });

  // # DashboardChangerView --------------------------------------------------

  /**
   * DashboardChangerView intercepts clicks on +el+ (the "change" button on
   * the right of the dashboard) and shows the user a pop-up which allows them
   * to change the constraints shown on the dash.
   */
  DashboardChangerView = Backbone.View.extend({
    id: 'dashboard-changer',

    events: {
      'submit form':         'commit',
      'click button.cancel': 'cancel'
    },

    /**
     * Creates a new DashboardChangerView. Expects that there be a "triggerEl"
     * option in the "options" object, which should contain the "change
     * dashboard" element.
     */
    initialize: function (options) {
      _.bindAll(this, 'render', 'cancel', 'commit', 'onComplete', 'onError');

      $(options.triggerEl).fancybox({
        // Rerender the view whenever the fancybox is shown, and use it's
        // contents in the box.
        content: this.render,

        // Misc styling.
        showCloseButton: false,
        padding: 0
      });
    },

    /**
     * Renders the template by adding the template elements to the main
     * element.
     *
     * Does not trigger showing the overlay; DashboardChangerView::show will
     * do both, so use that instead.
     */
    render: function () {
      $(this.el).html(DASHBOARD_CHANGER_T({}));
      this.delegateEvents();

      return this.el;
    },

    /**
     * Saves the changes made by the user, and then closes the FancyBox
     * overlay.
     */
    commit: function (event) {
      var formEl    = this.$('form'),
          inputEls  = this.$('input[name^=dash]:checked'),
          inputsLen = inputEls.length,
          data      = { dash: {} },

          name, input, i;

      for (i = 0; i < inputsLen; i++) {
        input = $(inputEls[i]);
        name  = input.attr('name').replace(/^dash\[(.*)\]$/, '$1');

        // Remove the extra stuff from the name so that we are left with only
        // the name of the dashboard group. e.g. dash[costs] => costs
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

      }).done(this.onComplete)
        .error(this.onError);

      this.$('.commit button').animate({ opacity: 0.4 });

      // The ajax indicator is shown after a short delay; this way it doesn't
      // begin fading in, only for the request to complete very quickly, and
      // the user wonder what suddenly popped up. This way it only appears if
      // the request seems to be lagging a bit.
      window.setTimeout(_.bind(function () {
        this.$('.commit .indicator').fadeIn('fast');
      }, this), 500);

      // The commit function may be used as a callback for a DOM event.
      if (event) { event.preventDefault(); }
    },

    /**
     * Discards any changes made by the user and hides the overlay.
     */
    cancel: function (event) {
      // TODO change this function to this.cancel.
      $.fancybox.close();

      // The cancel function may be used as a callback for a DOM event.
      if (event) { event.preventDefault(); }
    },

    // #### XHR Callbacks

    /**
     * Called upon successful completion of the XHR request.
     */
    onComplete: function (data, textStatus, jqXHR) {
      $.fancybox.close();

      console.log('done', data, textStatus, jqXHR);
    },

    /**
     * Called if an error occurred during the XHR request.
     */
    onError: function (jqXHR, textStatus, error) {
      console.log('error', jqXHR, textStatus, error);
    }

  });

  // # Globals ---------------------------------------------------------------

  window.DashboardChangerView = DashboardChangerView;

})(window);
