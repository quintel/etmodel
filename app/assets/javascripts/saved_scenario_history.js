/* globals $ App Backbone I18n */
(function (window) {
  var ScenarioHistoryView = Backbone.View.extend({
    events: {
      'click .edit-description': 'showTextArea',
      'click .submit-description': 'updateDescription',
      'click .cancel-description': 'hideTextArea',
      'click .restore-version': 'openDestroyModal',
    },

    constructor: function () {
      Backbone.View.apply(this, arguments);

      this.descriptionEl = this.el.querySelector('.description');
      this.descriptionEditEl = this.el.querySelector('.description-field');
      this.iconsEl = this.el.querySelector('.scenario-version');
      this.formControl = this.el.querySelector('.control');
    },

    render: function() {
      if (this.descriptionEditEl) {
        this.setupMaxLengthDescription(1000);
      }
    },

    setupMaxLengthDescription: function (max) {
      this.descriptionEditEl.querySelector('textarea').onkeypress = function () {
        if (this.value.length >= max) return false;
      };
    },


    showTextArea: function (event) {
      $(this.iconsEl).hide();
      $(this.descriptionEl).hide();
      $(this.formControl).show();
      $(this.descriptionEditEl).show();
      this.descriptionEditEl.querySelector('textarea').focus();
    },

    updateDescription: function(event) {
      let newText = this.descriptionEditEl.querySelector('textarea').value;

      if (newText == ''){
        this.hideTextArea();
        return;
      }

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
      $(this.formControl).hide();
      $(this.descriptionEditEl).hide();
    },

    openDestroyModal: function (event) {
      let url = $(event.target).data("url");

      $.fancybox.open({
        href: url,
        type: 'ajax',
        autoSize: false,
        height: 250,
        width: 550,
        padding: 0
      });
    },
  });

  window.ScenarioHistoryView = ScenarioHistoryView;
})(window);
