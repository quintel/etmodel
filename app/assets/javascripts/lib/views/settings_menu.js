/* globals $ Backbone */

(function(window) {
  'use strict';

  var SettingsMenuView = Backbone.View.extend({
    events: {
      'click .save-scenario': 'saveScenario'
    },

    saveScenario: function(event) {
      $('body').addClass('is-saving');
      window.Interface.close_all_menus();

      var request = $.ajax({
        url: event.target.dataset.path,
        data: {
          scenario_id: this.options.scenario.get('id')
        },
        dataType: 'json',
        method: 'put'
      });

      request.always(function() {
        $('body').removeClass('is-saving');
      });
    },

    render: function() {
      this.$el.find('.disabled').removeClass('disabled');

      // Update the ref for the "Save scenario as" link.
      var saveAs = this.$el.find('.save-as');
      saveAs.attr(
        'href',
        saveAs.data('path').replace(/:scenario_id/, this.options.scenario.get('id'))
      );
    }
  });

  window.SettingsMenuView = SettingsMenuView;
})(window);
