/* globals $ App Backbone I18n */
(function (window) {
  var MultiYearChartNewView = Backbone.View.extend({
    events: {
      'click .checkbox': 'validateCheckboxes',
    },

    constructor: function () {
      Backbone.View.apply(this, arguments);

      this.formEl = this.el.querySelector('form');
      this.validateCheckboxes();
    },

    render: function() {
      this.el.querySelector('#multi_year_chart_title').focus();
    },

    validateCheckboxes: function() {
      if (this.el.querySelectorAll('.checkbox:has(:checked)').length == 6) {
        this.formEl.classList.add('no-click');
      } else {
        this.formEl.classList.remove('no-click');
      }
    }
  });

  $(function () {
    new MultiYearChartNewView({ el: document.querySelector('#new-collection') }).render();
  });

  window.MultiYearChartNewView = MultiYearChartNewView;
})(window);
