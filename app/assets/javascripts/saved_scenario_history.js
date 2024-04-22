/* globals $ App Backbone I18n */
(function (window) {
  var ScenarioHistoryView = Backbone.View.extend({
    events: {
      'click .edit-description': 'showTextArea',
      'click .submit-description': 'updateDescription',
      'click .cancel-description': 'hideTextArea',
      // 'click .restore': 'restore', TODO: check if we need this
    },

    constructor: function () {
      Backbone.View.apply(this, arguments);

      this.descriptionEl = this.el.querySelector('.description');
      this.descriptionEditEl = this.el.querySelector('.description-field');
      this.iconsEl = this.el.querySelector('.scenario-version');
    },
    showTextArea: function (event) {
      $(this.iconsEl).hide();
      $(this.descriptionEl).hide();
      $(this.descriptionEditEl).show();
    },

    updateDescription: function(event) {
      let newText = this.descriptionEditEl.querySelector('textarea').value;
      let self = this;

      $.ajax({
        url: this.options.url + '/' + self.id,
        method: 'PUT',
        dataType: 'json',
        data: { description: newText },
        success: function () {
          self.descriptionEl.textContent = newText;
          self.hideTextArea();
        },
        error: function (response) {
          console.log('Failed to update!');
          console.log(response);
        }
      });
    },

    hideTextArea: function (event) {
      $(this.iconsEl).show();
      $(this.descriptionEl).show();
      $(this.descriptionEditEl).hide();
    },
  });

  window.ScenarioHistoryView = ScenarioHistoryView;
})(window);
