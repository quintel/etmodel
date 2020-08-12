/* globals $ Backbone I18n Interface ToastView */

(function(window) {
  'use strict';

  var SettingsMenuView = Backbone.View.extend({
    events: {
      'click .save-scenario': 'saveScenario'
    },

    saveScenario: function(event) {
      event.target.classList.add('disabled');

      var request = $.ajax({
        url: event.target.dataset.path,
        data: {
          scenario_id: this.options.scenario.get('id')
        },
        dataType: 'json',
        method: 'put'
      });

      request.always(function() {
        event.target.classList.remove('disabled');
        Interface.close_all_menus();
      });

      request.success(function() {
        ToastView.create('<span class="fa fa-check"></span> ' + I18n.t('toast.scenario_saved'), {
          className: 'success'
        }).start();
      });

      request.error(function() {
        ToastView.destroyAll();
      });
    },

    render: function() {
      this.$el.find('.disabled').removeClass('disabled');

      // Update the ref for the "Save scenario as" link.
      var replaceLinks = this.$el.find('.save-as, .scale-scenario');
      var self = this;

      replaceLinks.each(function(_index, element) {
        var anchor = $(element);

        anchor.attr(
          'href',
          anchor.data('path').replace(/:scenario_id/, self.options.scenario.get('id'))
        );
      });
    }
  });

  window.SettingsMenuView = SettingsMenuView;
})(window);
