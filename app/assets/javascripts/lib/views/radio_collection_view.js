/* globals _ $ Backbone I18n */

(function(window) {
  var RADIO_VALUES = {
    settings_heat_curve_set: [
      { key: 'default', value: 0 },
      { key: '1987', value: 1 }
    ]
  };

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
      descriptionEl = $('<span class="description" />').text(description);
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
          RADIO_VALUES[input.get('key')].map(function(option) {
            return renderOption(input, option.key, option.value);
          })
        )
      );

      this.updateSelected();

      return this;
    },

    /**
     * Triggered when the user selects an input element.
     */
    setValue: function(event) {
      var input = this.model;
      var target = event.target;
      var value = parseInt(target.value, 10);

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

      if (value === undefined) {
        // This happens when called by render before the input has had the user
        // value set (during initial page load).
        return;
      }

      value = parseInt(value, 10);

      this.$el.find('li').each(function(_i, listEl) {
        var radioEl = listEl.querySelector('input[name="' + key + '"]');
        var selected = parseInt(radioEl.value, 10) === value;

        radioEl.checked = selected;

        if (selected) {
          listEl.classList.add('is-selected');
        } else {
          listEl.classList.remove('is-selected');
        }
      });
    }
  });

  window.RadioCollectionView = RadioCollectionView;
})(window);
