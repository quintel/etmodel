/* globals $ Backbone */
(function(window) {
  var DropdownView = Backbone.View.extend({
    events: { 'click [data-toggle="dropdown"]': 'toggle' },

    constructor: function() {
      Backbone.View.apply(this, arguments);

      this.buttonEl = this.el.querySelector('[data-toggle="dropdown"]');
      this.dropdownEl = this.el.querySelector('.dropdown-menu');
      this.dismissEvent = this.dismissEvent.bind(this);
    },

    /**
     * Event triggered when the user clicks the dropdown button. May be manually called.
     *
     * @param {MouseEvent} event
     */
    toggle: function(event) {
      event && event.preventDefault();

      if (this.dropdownEl.classList.contains('show')) {
        this.dropdownEl.classList.remove('show');
        this.buttonEl.classList.remove('active');
        this.buttonEl.ariaExpanded = false;

        document.removeEventListener('click', this.dismissEvent);
      } else {
        this.dropdownEl.classList.add('show');
        this.buttonEl.classList.add('active');
        this.buttonEl.ariaExpanded = true;

        document.addEventListener('click', this.dismissEvent);
      }
    },

    /**
     * Event triggered whenever the user click anywhere in the window. If the click was inside the
     * dropdown, it is handled as normal. Otherwise the menu is dismissed.
     */
    dismissEvent: function(event) {
      var parent = event.target.closest('.dropdown');

      if (parent !== this.el) {
        this.toggle();
      }
    }
  });

  var HeaderView = Backbone.View.extend({
    render: function() {
      this.el.querySelectorAll('.dropdown').forEach(function(element) {
        new DropdownView({ el: element }).render();
      });
    }
  });

  $(function() {
    new HeaderView({ el: document.querySelector('header.main-header') }).render();
  });

  window.HeaderView = HeaderView;
  window.DropdownView = DropdownView;
})(window);
