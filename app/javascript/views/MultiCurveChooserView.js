/* globals _ $ Backbone I18n */

import CustomCurveChooserView from './CustomCurveChooserView';

/**
 * Takes an array of CustomCurve models and partitions them into two arrays.
 *
 * The first array contains the sorted collection of all curves which do not belong to a group. The
 * second contains two-element tuples, the first element being the localized group name, and the
 * second the sorted list of models belonging to that group.
 */
const partitionCurvesByGroup = (models) => {
  const grouped = [];
  const ungrouped = [];

  for (const model of models) {
    if (model.get('display_group')) {
      grouped.push(model);
    } else {
      ungrouped.push(model);
    }
  }

  let groupedCollection = Object.entries(_.groupBy(grouped, (model) => model.translatedGroup()));
  groupedCollection.sort(([aName], [bName]) => aName.localeCompare(bName));

  return [ungrouped, groupedCollection];
};

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
    const [ungrouped, groups] = partitionCurvesByGroup(this.options.curves.models);
    const select = $('<select />');

    // Add ungrouped curves first.
    for (const curve of ungrouped) {
      select.append($('<option />').val(curve.get('key')).text(this.curveName(curve)));
    }

    for (const [groupName, curves] of groups) {
      const optgroup = $('<optgroup />').attr('label', groupName);

      for (const curve of curves) {
        optgroup.append($('<option />').val(curve.get('key')).text(this.curveName(curve)));
      }

      select.append(optgroup);
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
      scenarios: this.currentCurve().get('type') === 'price' ? this.options.scenarios : [],
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

  static setupWithWrapper(el, curvesPromise, scenariosPromise) {
    $.when(curvesPromise, scenariosPromise).done(function (curves, scenarios) {
      el.querySelector('.loading').remove();
      new MultiCurveChooserView({ el, curves, scenarios }).render();
    });
  }
}

export default MultiCurveChooserView;
