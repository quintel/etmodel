/* globals $ Backbone I18n */

$(document).ready(function () {
  var SavedScenarioFormView

  function renderActions(options, t) {
    var actions = $('<div class="actions" />');

    if(options == 'show'){
      var editButton = $('<div class="edit button"/>').text(t('edit_text'));
      actions.append(editButton);
    }

    if(options == 'edit'){
      var cancelButton = $('<div class="cancel button"/>').text(t('cancel_text'));
      var saveButton = $('<div class="save button"/>').text(t('save_text'));
      actions.append(saveButton);
      actions.append(cancelButton);
    }

    return actions;
  }

  function resizeTextareas() {
    $("textarea").each( function() {
      $( this ).height('auto');
      $( this ).height($( this ).prop('scrollHeight'));
    });
  }

  /*
   * This view is basically an extension of the form that is already on the page.
   * The title and description are grabbed from the form fields for safekeeping,
   * may the user decide to discard their changes to the form.
   */
  SavedScenarioFormView = Backbone.View.extend({
    el: 'form',

    events: {
      'click .edit': 'renderEdit',
      'click .cancel': 'restore',
      'click .save': 'save'
    },

    initialize: function() {
      Backbone.View.prototype.initialize.apply(this, arguments);
      this.t = _.bind(this.t, this);

      this.title_field = $('.title textarea');
      this.description_field = $('.description textarea');

      // Guess I could also use a model for this - but that would overcomplicate things even more
      this.title = this.title_field[0].value;
      this.description = this.description_field[0].value;

      $(window).on("resize", resizeTextareas);
    },

    render: function(){
      this.renderShow();

      return this;
    },

    /*
     * Sets readonly properties of form fields to true and renders the edit
     * action button
     */
    renderShow: function(){
      this.title_field.prop('readonly', 'readonly');
      this.description_field.prop('readonly', 'readonly');

      resizeTextareas();

      // Set actions
      if (this.$el.data('editable') == true){
        $('.actions').remove();
        this.$el.append(renderActions('show', this.t));
      }
    },

    /*
     * Removes readonly properties from form fields to true and renders the save
     * and discard action buttons
     */
    renderEdit: function() {
      this.title_field.removeProp('readonly');
      this.description_field.removeProp('readonly');

      $('.actions').remove();
      this.$el.append(renderActions('edit', this.t));
    },

    /*
     * Submits the form and stores the saved title and description
     */
    save: function() {
      var saveData = this.$el.serialize();
      var url = this.$el[0].action;

      $.ajax({
        url: url,
        method: 'PUT',
        data: saveData
      });

      this.description = this.description_field[0].value;
      this.title = this.title_field[0].value;

      this.renderShow();
    },

    /*
     * Restores the form fields to their original, or post-save values
     */
    restore: function() {
      this.title_field.val(this.title);
      this.description_field.val(this.description);

      this.renderShow();
    },

    /*
     * Got the feeling I18n isn't fully loaded here
     */
    t: function(key) {
      console.log('the mystery of loading assets...');
      return I18n.t('scenario.' + key );
    }
  });

   new SavedScenarioFormView().render();
});

