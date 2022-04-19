/* globals $ App Backbone I18n */

(function (window) {
  'use strict';

  var preservedAttrs = new Set(['key', 'display_group', 'overrides', 'type']);

  var CustomCurve = Backbone.Model.extend({
    idAttribute: 'key',

    /**
     * Returns if there is a file attached for this curve.
     */
    isAttached: function () {
      return this.get('attached');
    },

    /**
     * Returns true if the curve was imported from another scenario.
     */
    isFromScenario: function () {
      return !$.isEmptyObject(this.get('source_scenario'));
    },

    /**
     * The translated, human-readable name for the curve.
     */
    translatedName: function () {
      return I18n.t('custom_curves.names.' + this.id);
    },

    /**
     * The translated, human-readable name for the group to which the curve belongs or an empty
     * string if the curve does not belong to a group.
     */
    translatedGroup: function () {
      if (!this.get('display_group')) {
        return '';
      }

      return I18n.t('custom_curves.groups.' + this.get('display_group'));
    },

    /**
     * Removes all attributes and returns the CustomCurve to an unattached state.
     */
    purge: function () {
      for (var key in this.attributes) {
        if (!preservedAttrs.has(key) && this.has(key)) {
          if (key === 'attached') {
            this.set('attached', false);
          } else {
            this.unset(key);
          }
        }
      }
    },

    /**
     * Sets any related inputs to be enabled or disabled depending on whether a file is attached.
     */
    refreshInputState: function () {
      var overrides = this.get('overrides');
      var isAttached = this.isAttached();

      if (!overrides || overrides.length === 0) {
        return;
      }

      for (var i = 0; i < overrides.length; i++) {
        App.input_elements.markInputDisabled(overrides[i], 'custom-curve', isAttached);
      }
    },
  });

  var CustomCurveCollection = Backbone.Collection.extend({
    model: CustomCurve,

    /** Sorts curves by their translated name. */
    comparator: function (a, b) {
      return a
        .translatedName()
        .localeCompare(b.translatedName(), I18n.locale, { numeric: true, sensitivity: 'base' });
    },

    getOrBuild: function (id) {
      if (!this.get(id)) {
        this.add(new CustomCurve({ key: id }));
      }

      return this.get(id);
    },

    publicCurves: function () {
      this.models.filter(function (model) {
        return !model.get('internal');
      });
    },
  });

  // Globals -----------------------------------------------------------------

  window.CustomCurve = CustomCurve;
  window.CustomCurveCollection = CustomCurveCollection;
})(window);
