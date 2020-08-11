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
          scenario_id: this.options.scenario.api_session_id()
        },
        dataType: 'json',
        method: 'put'
      });

      request.always(function() {
        $('body').removeClass('is-saving');
      });
    }
  });

  window.SettingsMenuView = SettingsMenuView;
})(window);
