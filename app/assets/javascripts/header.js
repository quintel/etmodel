/* globals $ App Backbone I18n */
(function (window) {
  var DropdownView = Backbone.View.extend({
    events: {
      'click [data-toggle="dropdown"]': 'toggle',
      'click .dropdown-item': 'onClickItem',
    },

    constructor: function () {
      Backbone.View.apply(this, arguments);

      this.buttonEl = this.el.querySelector('[data-toggle="dropdown"]');
      this.dropdownEl = this.el.querySelector('.dropdown-menu');
      this.dismissEvent = this.dismissEvent.bind(this);
      this.finishDismissEvent = this.finishDismissEvent.bind(this);
    },

    /**
     * Event triggered when the user clicks the dropdown button. May be manually called.
     *
     * @param {MouseEvent} event
     */
    toggle: function (event) {
      event && event.preventDefault();

      if (this.dropdownEl.classList.contains('show')) {
        this.dropdownEl.classList.remove('show');
        this.buttonEl.classList.remove('active');
        this.buttonEl.ariaExpanded = false;

        document.removeEventListener('mousedown', this.dismissEvent);
      } else {
        this.dropdownEl.classList.add('show');
        this.buttonEl.classList.add('active');
        this.buttonEl.ariaExpanded = true;

        document.addEventListener('mousedown', this.dismissEvent);
      }
    },

    /**
     * When clicking a link in the dropdown, dismiss the dropdown but don't prevent the default
     * event from firing.
     *
     * This ensures the dropdown is hidden when clicking a link which is intercepted by JS.
     */
    onClickItem: function () {
      this.toggle();
    },

    /**
     * Event triggered whenever the user click anywhere in the window. This begins the process of
     * dismissing the dropdown if the user starts the click outside the dropdown element.
     *
     * If the initial click is within the element, the dropdown will not be dismissed; such a thing
     * can occur when editing a text field, and the user click/drags the contents of the field,
     * ending with the mouseup occuring outside the dropdown.
     */
    dismissEvent: function (event) {
      this.shouldDismiss = event.target.closest('.dropdown') !== this.el;
      document.addEventListener('mouseup', this.finishDismissEvent, { once: true });
    },

    /**
     * Triggered when the user finishes their mouseclick.
     */
    finishDismissEvent: function () {
      if (this.shouldDismiss) {
        this.toggle();
      }
    },
  });

  /**
   * Main navigation pop-up which allows the visitor to provide a feedback message for the current
   * page.
   */
  var FeedbackView = Backbone.View.extend({
    events: {
      'click button.cancel': 'dismiss',
      'input textarea': 'enableDisableSend',
      submit: 'onSubmit',
    },

    /**
     * Triggered when the feedback pop-up is dismissed; either by the user cancelling or when the
     * feedback was successfully sent.
     */
    dismiss: function (event) {
      event && event.preventDefault();

      var textarea = this.$el.find('textarea');
      var success = this.$el.find('.success');
      var failure = this.$el.find('.failure');

      // Reset text area with a delay to prevent the text from disappearing immediately, as this
      // looks unpleasant.
      window.setTimeout(function () {
        textarea.val('').css({ opacity: '1' }).attr('disabled', false);
        success.hide();
        failure.hide();
      }, 200);

      // Dismiss the dropdown.
      this.el.closest('.dropdown').querySelector('button.nav-link').click();
    },

    /**
     * Event triggered whenever the visitor types, enabling or disabling the send button.
     */
    enableDisableSend: function () {
      this.$el
        .find('button.send')
        .attr('disabled', this.$el.find('textarea').val().trim().length === 0);
    },

    handleFailure: function () {
      this.$el.find('textarea').attr('disabled', false);
      this.$el.find('button.cancel').attr('disabled', false);
      this.$el.find('button.send').removeClass('loading');
      this.$el.find('.failure').show();

      this.enableDisableSend();
    },

    /**
     * Event triggered when the feedback was successfully sent.
     */
    handleSuccess: function () {
      this.$el.find('button.send').removeClass('loading').attr('disabled', true);

      this.$el.find('textarea').animate({ opacity: 0 });
      this.$el.find('.success').fadeIn();

      this.$el.find('button.cancel').attr('disabled', false);

      var self = this;

      window.setTimeout(function () {
        self.dismiss();
      }, 3000);
    },

    /**
     * Triggered when the visitor submits their feedback.
     */
    onSubmit: function (event) {
      event.preventDefault();

      var sendButton = this.$el.find('.buttons .primary');

      sendButton
        .css({ minWidth: sendButton.outerWidth() })
        .addClass('loading')
        .attr('disabled', 'disabled');

      this.$el.find('.buttons .cancel').attr('disabled', 'disabled');
      this.$el.find('.failure').hide();

      var text = this.$el.find('textarea').attr('disabled', true).val();

      if (text.length === 0) {
        return;
      }

      var payload = {
        locale: I18n.locale,
        page: window.location.pathname,
        text: text,
      };

      if (window.App) {
        payload.charts = App.charts.map(function (chart) {
          return chart.get('key');
        });

        payload.scenario_id = App.settings.get('api_session_id');
        payload.saved_scenario_id = App.settings.get('active_saved_scenario_id');
      }

      var req = $.ajax({
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(payload),
        dataType: 'json',
        method: event.target.method,
        url: event.target.action,
      });

      req.then(this.handleSuccess.bind(this));
      req.error(this.handleFailure.bind(this));
    },
  });

  var HeaderView = Backbone.View.extend({
    events: {
      'click #locale-button': 'updateLocaleLinks',
      'click #feedback-button': 'focusFeedbackField',
    },

    focusFeedbackField: function (event) {
      if (!event.target.classList.contains('active')) {
        return false;
      }

      event.target.closest('.dropdown').querySelector('textarea').focus();
    },

    render: function () {
      this.el.querySelectorAll('.dropdown').forEach(function (element) {
        new DropdownView({ el: element }).render();
      });

      new FeedbackView({ el: this.el.querySelector('.feedback-item form') }).render();
    },

    updateLocaleLinks: function (event) {
      var links = event.target.closest('.dropdown').querySelectorAll('.dropdown-menu a');
      var path = window.location.pathname;

      links.forEach(function (linkEl) {
        var locale = linkEl.href.match(/locale=(\w+)/);

        if (locale && locale[1]) {
          linkEl.href = path + '?locale=' + locale[1];
        }
      });
    },
  });

  $(function () {
    new HeaderView({ el: document.querySelector('header.main-header') }).render();
  });

  window.HeaderView = HeaderView;
  window.DropdownView = DropdownView;
})(window);
