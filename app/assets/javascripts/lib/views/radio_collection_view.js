/* globals _ $ App Backbone I18n */

(function(window) {
  function renderOption(input, key, value) {
    var inputEl = $('<input type="radio" />')
      .attr('name', input.get('key'))
      .attr('value', value);

    var i18nPrefix = 'radio_elements.' + input.get('key') + '.' + key + '.';

    var title = I18n.t(i18nPrefix + 'title');
    var description = I18n.t(i18nPrefix + 'description', {
      defaultValue: ''
    });

    var titleEl = $('<strong class="title" />').text(title);
    var descriptionEl;

    if (description.length) {
      descriptionEl = $('<span class="description" />').html(description);
    }

    return $('<li></li>').append(
      $('<label></label>').append(inputEl, titleEl, descriptionEl)
    );
  }

  /**
   * A Base class for radio buttons which send values as inputs to ETEngine.
   *
   * Required options:
   *
   * @option {InputElement} input
   *   An instance of InputElement which will have a key set and whose value can
   *   be changed when the user selects a new option.
   * @option {Element} el
   *   Wrapper element which contains one or more inputs whose "value" matches
   *   the input key. When the user changes which input value is selected, the
   *   InputElement will be updated accordingly.
   */
  var RadioCollectionView = Backbone.View.extend({
    events: {
      'click input': 'setValue'
    },

    initialize: function() {
      Backbone.View.prototype.initialize.apply(this, arguments);

      this.updateSelected = _.bind(this.updateSelected, this);
      this.render = _.bind(this.render, this);

      this.model.on('change:user_value', this.updateSelected, this);

      // Render when the document is ready.
      $(this.render);
    },

    closeInfoBox: function() {},

    render: function() {
      var input = this.model;

      this.$el.empty();

      this.$el.append(
        $('<ul class="radio-collection-view"></ul>').append(
          this.model.get('permitted_values').map(function(option) {
            return renderOption(input, option.toString(), option.toString());
          })
        )
      );

      this.updateSelected();

      this.model.handle_radio_callbacks();

      return this;
    },

    /**
     * Triggered when the user selects an input element.
     */
    setValue: function(event) {
      var input = this.model;
      var target = event.target;
      var value = target.value;

      if (
        target.name !== input.get('key') ||
        input.get('user_value') === value
      ) {
        return false;
      }

      input.set('user_value', value);
    },

    /**
     * Update the radio buttons to check the button matching the selectedValue.
     */
    updateSelected: function() {
      var value = this.model.get('user_value');
      var key = this.model.get('key');
      var options = this.model.get('permitted_values');

      // If the radio option is a numeric value it is (wrongly) parsed as a
      // number.
      value = value.toString();

      if (options.indexOf(value) === -1) {
        value = options[0];
      }

      this.$el.find('li').each(function(_i, listEl) {
        var radioEl = listEl.querySelector('input[name="' + key + '"]');
        var selected = radioEl.value === value;

        radioEl.checked = selected;

        if (selected) {
          listEl.classList.add('is-selected');
        } else {
          listEl.classList.remove('is-selected');
        }
      });
    }
  });

  /**
   * A list of inputs which should be disabled whenever the user selects a
   * non-default value for the weather curve input.
   */
  var WEATHER_CURVE_DEPENDENTS = [
    'flexibility_outdoor_temperature',
    'flh_of_energy_power_wind_turbine_coastal',
    'flh_of_energy_power_wind_turbine_inland',
    'flh_of_energy_power_wind_turbine_offshore',
    'flh_of_energy_power_hybrid_wind_turbine_offshore',
    'flh_of_energy_power_solar_pv_solar_radiation',
    'flh_of_households_solar_pv_solar_radiation',
    'flh_of_buildings_solar_pv_solar_radiation',
    'flh_of_energy_power_solar_pv_offshore'
  ];

  /**
   * Custom version of the RadioCollectionView which will trigger the disabling
   * of some inputs when the user selects a non-default weather curve.
   */
  var WeatherCurveView = RadioCollectionView.extend({
    setValue: function() {
      RadioCollectionView.prototype.setValue.apply(this, arguments);
      this.toggleDependents();
    },

    render: function() {
      RadioCollectionView.prototype.render.apply(this, arguments);
      this.toggleDependents();
    },

    toggleDependents: function() {
      var userValue = this.model.get('user_value');
      var defaultValue = this.model.get('start_value');

      var shouldDisable = userValue !== undefined && userValue !== defaultValue;
      var collection = this.model.collection;

      WEATHER_CURVE_DEPENDENTS.forEach(function(dependentKey) {
        var dependent = collection.find_by_key(dependentKey);

        if (!dependent) {
          App.debug('No such input to enable/disable: ' + dependentKey);
        } else {
          App.input_elements.markInputDisabled(dependent.get('key'), 'weather-set', shouldDisable)
        }
      });
    }
  });

  window.RadioCollectionView = RadioCollectionView;
  window.WeatherCurveView = WeatherCurveView;
})(window);
