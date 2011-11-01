(function (window) {
  'use strict';

  var DashboardChangerView;

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
        content: '<p>Hello world!</p>',

        height:  400,
        width:   600
      });

      event.preventDefault();
    }

  });

  // # Globals ---------------------------------------------------------------

  window.DashboardChangerView = DashboardChangerView;

})(window);
