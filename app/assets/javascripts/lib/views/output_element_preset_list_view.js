/* globals Backbone App */

(function (window) {
  'use strict';

  var OutputElementPresetListView = Backbone.View.extend({
    events: {
      'click .dropdown-menu button': 'loadPreset',
    },

    loadPreset: function (event) {
      const elements = event.target.dataset.outputElements;

      App.settings
        .save({ locked_charts: elements.length === 0 ? [] : elements.split(',') })
        .done(function () {
          location.reload();
        });
    },
  });

  // # Globals ---------------------------------------------------------------

  window.OutputElementPresetListView = OutputElementPresetListView;
})(window);
