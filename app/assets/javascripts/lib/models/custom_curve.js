/* globals $ Backbone */

(function(window) {
  'use strict';

  var CustomCurve = Backbone.Model.extend({
    idAttribute: 'type',

    /**
     * Returns if there is a file attached for this curve.
     */
    isAttached: function() {
      return !!this.get('size');
    },

    /**
     * Returns true if the curve was imported from another scenario.
     */
    isFromScenario: function() {
      return !$.isEmptyObject(this.get('source_scenario'));
    },

    /**
     * Removes all attributes and returns the CustomCurve to an unattached
     * state.
     */
    purge: function() {
      for (var key in this.attributes) {
        if (
          key !== 'type' &&
          Object.prototype.hasOwnProperty.call(this.attributes, key)
        ) {
          this.unset(key);
        }
      }
    }
  });

  var CustomCurveCollection = Backbone.Collection.extend({
    model: CustomCurve,

    getOrBuild: function(id) {
      if (!this.get(id)) {
        this.add(new CustomCurve({ type: id }));
      }

      return this.get(id);
    }
  });

  // Globals -----------------------------------------------------------------

  window.CustomCurve = CustomCurve;
  window.CustomCurveCollection = CustomCurveCollection;
})(window);
