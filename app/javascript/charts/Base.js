/* globals $ App Backbone I18n MeritOrderExcessTableView Metric Quantity TableView */

/**
 * Contains share functionality for charts. All charts inherit from this base class.
 *
 * This class handles triggering rendering the data as a chart or table, setting up loading or
 * empty-state messages, and the control buttons.
 */
export default class extends Backbone.View {
  /**
   * Customise the way the table-view is rendered. Possibilities are:
   *
   * labelFormatter: A function which should return a function; used to format
   *                 the label for each row.
   *
   * valueFormatter: A function which should return a function; used to format
   *                 the present and value in each row.
   *
   * sorter:         A function which should return a function; receives the
   *                 entire series, and should return the series sorted as
   *                 desired.
   *
   * For example:
   *
   *   tableOptions = {
   *     labelFormatter: serie => serie.get('label'),
   *     valueFormatter: value => Math.round(value),
   *     sorter:         series => series.reverse()
   *   }
   */
  tableOptions = {};

  /**
   * The name of the table view to be used when showing the chart as a table.
   */
  tableView = 'default';

  constructor(...args) {
    super(...args);

    this.model.bind('refresh', this.renderContent);
    this.model.bind('willReplace', this.prepareReplace);
  }

  /**
   * Triggered when a "willReplace" event is fired on the model. Removes action buttons and shows a
   * loading block while data for the new chart is loaded.
   */
  prepareReplace = () => {
    const loadingEl = $('<div class="loading" />');
    let canvas = this.$el.find('.chart_canvas');

    if (canvas.length > 0) {
      // Set the height of the loading element to be the same as the chart it
      // replaces to prevent a second/third/... chart from jumping up and down
      // the page. Don't bother if this is the only chart.
      if (this.model.collection.length > 1) {
        loadingEl.css({ height: canvas.height() - 1 });
      }
    } else {
      canvas = this.$el.find('.table_canvas');
    }

    canvas.empty().append(loadingEl);

    this.$el.find('header h3').text('Loading');
    this.$el.find('.actions').hide();

    this.model.set({ will_replace: true });
  };

  // Separate chart and table rendering
  /**
   * A controller method which determines how to render the contents of the chart and then triggers
   * the appropriate action.
   *
   * This is called when the chart first loads, and again whenever the underlying data is updated.
   */
  renderContent = () => {
    if (this.requiresHourlyData() && !App.settings.merit_order_enabled()) {
      this.containerNode().html(
        $('<div>')
          .html(I18n.t('wells.warning.merit'))
          .addClass('well')
      );

      this.drawn = false;
      return;
    }

    this.updateHeaderButtons();

    const isTable =
      (this.model.get('as_table') && this.canRenderAsTable()) ||
      this.model.get('type') === 'html_table';

    this.containerNode()
      .toggleClass('chart_canvas', !isTable)
      .toggleClass('table_canvas', isTable);

    if (isTable) {
      // TODO "html_table" should alias render() as renderAsTable()
      this.renderAsTable();
    } else {
      this.render();
    }
  };

  /**
   * Sets whether the chart requires hourly calculations to be enabled in order to render. Attempts
   * to render an hourly chart while the feature is disabled will show a notification instead of the
   * chart.
   */
  requiresHourlyData() {
    return this.model.get('requires_merit_order');
  }

  containerID() {
    return this.model.get('container');
  }

  // This is the dom element that will be filled with the chart. jqPlot expects
  // an id
  containerNode() {
    return $(`#${this.containerID()}`);
  }

  clearContainer() {
    this.containerNode().empty();
    return (this.drawn = false);
  }

  /**
   * Updates the header buttons when the chart or table is rendered.
   */
  updateHeaderButtons() {
    // Skip re-rendering if this chart is about to be replaced.
    if (this.model.get('will_replace')) {
      return;
    }

    const id = this.model.get('chart_id');

    this.$el.data('chart_id', id);
    this.$el.find('h3').html(this.model.get('name'));
    this.$el.find('a.chart_info').toggle(this.model.get('has_description'));
    this.$el.find('.actions a.chart_info').attr('href', `/descriptions/charts/${id}`);
    this.$el.find('.actions a.zoom_chart').attr('href', `/output_elements/${id}/zoom`);

    this.$el.find('.actions a').removeClass('loading');

    this.format_wrapper =
      this.$el.parents('.fancybox-inner').length > 0
        ? this.$el.parents('.fancybox-inner')
        : this.$el;

    this.format_wrapper.find('a.chart_format, a.table_format').hide();

    if (this.canRenderAsTable()) {
      if (this.model.get('as_table')) {
        this.format_wrapper.find('a.chart_format').show();
      } else {
        this.format_wrapper.find('a.table_format').show();
      }
    }

    this.$el.find('a.default_chart').toggle(this.model.wants_default_button());
    this.$el.find('a.show_related').toggle(this.model.wants_related_button());
    this.$el.find('a.show_previous').toggle(this.model.wants_previous_button());

    this.updateLockIcon();
    this.$el.find('.actions').show();
  }

  /**
   * Sets the lock/unlock button to have to correct icon depending on the current state of the
   * chart.
   */
  updateLockIcon() {
    const icon = this.$el.find('a.lock_chart');

    if (this.model.get('locked')) {
      icon.removeClass('fa fa-unlock').addClass('fa fa-lock');
    } else {
      icon.removeClass('fa fa-lock').addClass('fa fa-unlock');
    }
  }

  toggleFormat() {
    const tbl = this.model.get('as_table');
    this.renderContent();
    this.format_wrapper.find('a.table_format').toggle(!tbl);
    this.format_wrapper.find('a.chart_format').toggle(tbl);
  }

  hideFormatToggler() {
    $('a.toggle_chart_format').hide();
  }

  // Internal: Returns a function which can format and scale values on an axis,
  // ensuring that all returned formatted values are in the same unit.
  createScaler(max_value, unit, opts) {
    opts = opts || {};

    if (Quantity.isSupported(unit)) {
      return Quantity.scaleAndFormatBy(max_value, unit, opts);
    } else {
      return value => Metric.autoscale_value(value, unit, opts.precision, opts.scaledown);
    }
  }

  // Internal: Returns a function which will format values for the "main" axis
  // of the chart.
  createValueFormatter(opts) {
    opts = opts || {};

    const maxValue = (() => {
      if (opts.maxFrom === 'maxValue') {
        return this.model.max_value();
      } else {
        const max = this.model.max_series_value();
        const min = Math.abs(this.model.min_series_value());

        if (max > min) {
          return max;
        } else {
          return min;
        }
      }
    })();

    return this.createScaler(maxValue, this.model.get('unit'), opts);
  }

  // Derived classes can override this
  //
  canRenderAsTable() {
    return true;
  }

  /**
   * Renders the data for the chart in a table, instead of as a chart.
   */
  renderAsTable() {
    this.clearContainer();

    const Table = this.tableViewFor();

    return this.containerNode()
      .removeClass('chart_canvas')
      .addClass('table_canvas')
      .html(new Table(this, this.tableOptions).render());
  }

  /**
   * Returns the View to be used to render data as a table.
   */
  tableViewFor() {
    switch (this.tableView) {
      case 'merit_order_excess_table':
        return MeritOrderExcessTableView;
      case 'default':
        return TableView;
    }
  }
}
