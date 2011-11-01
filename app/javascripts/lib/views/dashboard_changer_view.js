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

        height:  400,
        padding:   0,
        width:   600
      });

      event.preventDefault();
    }

  });

  // # Globals ---------------------------------------------------------------

  window.DashboardChangerView = DashboardChangerView;

})(window);
