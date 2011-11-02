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
      'click button.save':   'commit',
      'click button.cancel': 'cancel'
    },

    /**
     * Creates a new DashboardChangerView. Expects that there be a "triggerEl"
     * option in the "options" object, which should contain the "change
     * dashboard" element.
     */
    initialize: function (options) {
      _.bindAll(this, 'render', 'cancel', 'commit');

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
      var checkedEls = this.$('input[name^=dash]:checked'),
          checkedLen = checkedEls.length,
          element;

      while (checkedLen--) {
        element = $(checkedEls[checkedLen]);

        console.log(element.attr('name'), ' -> ', element.val(),
                    element.parent('label').text());
      }

      this.$('.commit .indicator').fadeIn('fast');
      this.$('.commit button').animate({ opacity: 0.4 });

      // Simulate a slightly delayed HTTP request.
      window.setTimeout(function () { $.fancybox.close(); }, 2000);

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
    }

  });

  // # Globals ---------------------------------------------------------------

  window.DashboardChangerView = DashboardChangerView;

})(window);
