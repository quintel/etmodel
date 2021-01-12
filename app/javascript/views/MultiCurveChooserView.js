/* globals _ $ Backbone I18n */

import CustomCurveChooserView from './CustomCurveChooserView';

/**
 * Renders the select which allows the user to choose which curve to view. Updates the titles
 * whenever a curve is added or removed.
 */
class CurveSelectView extends Backbone.View {
  get events() {
    return { 'change select': 'refreshTitle' };
  }

  curveName(curve) {
    return `${curve.translatedName()}${
      curve.get('attached') ? ` (${I18n.t('custom_curves.uploaded')})` : ''
    }`;
  }

  refresh = (curve) => {
    if (!document.body.contains(this.el)) {
      // Unbind if the select has been removed from the page.
      this.options.curves.off('change:attached', this.refresh);
      return;
    }

    const option = this.$el.find(`option[value="${curve.id}"]`);

    if (option) {
      option.text(this.curveName(curve));
    }
  };

  refreshTitle(event) {
    this.$el.find('.title').text(this.options.curves.get(event.target.value).translatedName());
  }

  render() {
    const sorted = _.sortBy(this.options.curves.models, (model) => model.translatedName());
    const select = $('<select />');

    for (const curve of sorted) {
      select.append($('<option />').val(curve.get('key')).text(this.curveName(curve)));
    }

    this.$el.append(select);

    this.$el.append(
      $('<div class="title-wrapper" />').append(
        $('<span class="title" />'),
        $('<span class="fa fa-chevron-down" />')
      )
    );

    this.options.curves.on('change:attached', this.refresh);

    return this.el;
  }
}

/**
 * Container view which renders the select, allowing the user to choose which curve to view or
 * change, and a CustomCurveChooserView for the selected curve itself.
 */
class MultiCurveChooserView extends Backbone.View {
  get events() {
    return { 'change .select-curve select': 'onSelectCurve' };
  }

  currentCurve() {
    return this.options.curves.get(this.currentCurveKey);
  }

  onSelectCurve(event) {
    this.currentCurveKey = event.target.value;

    if (this.activeSubview) {
      this.activeSubview.remove();
    }

    const container = $('<div />');
    this.$el.find('.curve-info').append(container);

    this.activeSubview = new CustomCurveChooserView({
      el: container,
      model: this.currentCurve(),
      scenarios: [],
    });

    this.activeSubview.render();
  }

  render() {
    this.$el.append(
      $('<div class="select-curve" />').append(
        new CurveSelectView({ curves: this.options.curves }).render()
      )
    );

    this.$el.append($('<div class="curve-info"></div>'));
    this.$el.find('.select-curve select').change();

    return this.el;
  }

  static setupWithWrapper(el, curveCollectionDef) {
    curveCollectionDef.then((data) => {
      el.querySelector('.loading').remove();
      new MultiCurveChooserView({ el, curves: data }).render();
    });
  }
}

export default MultiCurveChooserView;
