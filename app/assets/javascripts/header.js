/* globals $ App Backbone I18n */
(function (window) {
  var DropdownView = Backbone.View.extend({
    events: {
      'click .dropdown-item': 'onClickItem',
    },

    constructor: function () {
      Backbone.View.apply(this, arguments);

      this.buttonEl = this.el.querySelector('[data-toggle="dropdown"]');
      this.dropdownEl = this.el.querySelector('.dropdown-menu');
      this.dismissEvent = this.dismissEvent.bind(this);
      this.finishDismissEvent = this.finishDismissEvent.bind(this);

      if (this.buttonEl.dataset.dropdownTrigger === 'hover') {
        this.el.addEventListener('mouseenter', this.toggle.bind(this));
        this.el.addEventListener('mouseleave', this.toggle.bind(this));
      } else {
        this.buttonEl.addEventListener('click', this.toggle.bind(this));
      }
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

  var HeaderView = Backbone.View.extend({
    events: {
      'click #locale-button': 'updateLocaleLinks',
    },

    render: function () {
      this.el.querySelectorAll('.dropdown').forEach(function (element) {
        new DropdownView({ el: element }).render();
      });
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
    new HeaderView({ el: document.querySelector('.main-header') }).render();
  });

  window.HeaderView = HeaderView;
  window.DropdownView = DropdownView;
})(window);
