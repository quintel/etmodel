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
    events: {
      'click': 'show'
    },

    initialize: function (options) {
      _.bindAll(this, 'show');
    },

    /**
     * Shows the overlay allowing the user to select different constraints to
     * be shown. Used as the onClick event for the "change" button.
     */
    show: function (event) {
      $(this.el).fancybox({
        content: DASHBOARD_CHANGER_T({}),

        onComplete: _.bind(function () {
          // Clicking on the "Cancel" button within the fancybox element
          // should hide the changer view.
          $('#dashboard-changer .commit .cancel').click(this.cancel);
        }, this),

        showCloseButton: false,
        padding:         0
      });

      event.preventDefault();
    },

    /**
     * Discards any changes made by the user and hides the overlay.
     */
    cancel: function (event) {
      // TODO change this function to this.cancel.
      $.fancybox.close();

      // The cancel function may be used as a callback for a DOM event.
      if (event) { event.preventDefault(); }
    }

  });

  // # Globals ---------------------------------------------------------------

  window.DashboardChangerView = DashboardChangerView;

})(window);
