/* globals $ Backbone */

(function(window) {
  'use strict';

  var ToastView = Backbone.View.extend({
    id: 'toast-notification',

    events: {
      click: 'close'
    },

    render: function() {
      this.$el.append($('<span class="text"></span>').html(this.options.text));

      if (this.options.className) {
        this.$el.addClass(this.options.className);
      }

      return this.$el;
    },

    /**
     * Starts a three-second timeout to remove the toast from view.
     */
    start: function(duration) {
      var progress = $('<div class="progress"></div>');
      var animationDuration = duration || 3000;

      this.$el.append(progress);

      progress.animate({ width: '250px' }, animationDuration, 'linear');
      window.setTimeout(this.close.bind(this), animationDuration);
    },

    close: function() {
      var self = this;

      self.$el.fadeOut(150, function() {
        self.remove();
      });
    }
  });

  /**
   * Creates a new ToastView and displays it. Any existing toast is removed prior to displaying the
   * new toast.
   *
   * @returns {ToastView}
   */
  ToastView.create = function(text, options) {
    var existing = $('body #toast-notification');
    var toast = new ToastView($.extend({}, { text: text }, options));

    toast.render();
    toast.$el.hide();

    $('body').prepend(toast.$el);
    toast.$el.data('toast', toast);

    if (existing.length) {
      // Remove any existing notification. Stacks are not supported.
      existing.data('toast').remove();

      // Immediately add the new toast without fading in.
      toast.$el.fadeIn(150);
    } else {
      toast.$el.fadeIn(150);
    }

    return toast;
  };

  /**
   * Immediately removes all toasts.
   */
  ToastView.destroyAll = function() {
    var existing = $('body #toast-notification');

    if (existing.length) {
      existing.data('toast').remove();
    }
  };

  window.ToastView = ToastView;
})(window);
