/* globals $ Backbone */

class LegendItem extends Backbone.View {
  events = { click: 'onClick' };

  onClick = (event) => {
    if (!this.isClickable()) {
      return;
    }

    event.preventDefault();

    this.$el.toggleClass('active');
    this.options.active = !this.options.active;

    this.options.onClick(event, this.options);
  };

  isClickable() {
    return this.options.clickable && !this.options.isLine;
  }

  render() {
    // This has to be called manually, due to Backbone not picking up the events object (probably
    // need to update Backbone).
    this.delegateEvents(this.events);

    this.$el.addClass('legend-item');

    this.$el.append(
      $('<span class="click-wrapper" />').append(
        $('<span class="rect" />').css('background-color', this.options.color),
        $('<span />').text(this.options.label)
      )
    );

    if (this.options.width) {
      this.$el.css('width', this.options.width);
    }

    if (this.options.isLine) {
      this.$el.addClass('target-line');
    } else if (this.options.clickable) {
      this.$el.addClass('clickable');

      if (this.options.active) {
        this.$el.addClass('active');
      }
    }

    return this.el;
  }
}

class Legend extends Backbone.View {
  constructor(options = {}) {
    super({
      clickable: true,
      columns: 2,
      marginLeft: 0,
      items: [],
      onClickItem: () => {},
      ...options,
    });
  }

  render() {
    // This has to be called manually, due to Backbone not picking up the events object (probably
    // need to update Backbone).
    this.delegateEvents(this.events);

    if (this.options.marginLeft) {
      this.el.style.marginLeft = `${this.options.marginLeft}px`;
    }

    this.el.classList.add('legend');

    const width = `${Math.round(100 / this.options.columns)}%`;
    const clickable = this.options.clickable;

    for (const series of this.options.items) {
      this.el.append(
        new LegendItem({
          clickable,
          active: !series.get('hidden'),
          color: series.get('color'),
          isLine: series.get('is_target_line'),
          key: series.get('id'),
          label: series.get('label'),
          onClick: this.options.onClickItem,
          series,
          width,
        }).render()
      );
    }

    return this.el;
  }
}

export default Legend;
