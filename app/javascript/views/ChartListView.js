/* globals $ App Backbone I18n */

/**
 * A simple fuzzy text matcher, inspired by bevacqua/fuzzysearch (MIT License).
 *
 * Whereas fuzzysearch.js matches one string against another, where each character may appear
 * anywhere, this version matches tokens where each searchToken must be a substring of a textToken.
 *
 * @example
 *   // Matches
 *   search(['fi', 'd'], ['final', 'energy', 'demand'])
 *
 *   // Does not match, because "fi" is not a substring of any of the second argument tokens.
 *   // fuzzystring.js would match this: the "f" from "four" and the "e" from "candles".
 *   search(['fe'], ['four', 'candles'])
 *
 *   // Tokens may match in any order.
 *   search(['de', 'fi'], ['final', 'energy', 'demand']) // => true
 */
const search = (searchTokens, textTokens) => {
  let sLength = searchTokens.length;
  let tLength = textTokens.length;

  if (sLength > tLength) {
    return false;
  }

  outer: for (let sIndex = 0; sIndex < sLength; sIndex++) {
    for (let tIndex = 0; tIndex < tLength; tIndex++) {
      if (textTokens[tIndex].includes(searchTokens[sIndex])) {
        // Matches search token, move to the next one.
        continue outer;
      }
    }

    // No more text tokens to to match against the search token.
    return false;
  }

  return true;
};

/**
 * Given data for a list item, the onSelectChart and isElementDisabled callbacks (see
 * ChartListView#render) returns the element as a ListItem.
 */
const createElement = (el, onSelectChart, isElementDisabled) => {
  switch (el.type) {
    case 'group':
    case 'subgroup':
      return new GroupListItem({ isElementDisabled, onSelectChart, ...el });
    default:
      return new ChartListItem({ isElementDisabled, onSelectChart, ...el });
  }
};

/**
 * Given an array of elements, the onSelectChart and isElementDisabled callbacks (see
 * ChartListView#render) returns an array of the elements transformed to ListItems.
 */
const createElements = (elements = [], onSelectChart, isElementDisabled) => {
  return elements.map((el) => createElement(el, onSelectChart, isElementDisabled));
};

class ListItem extends Backbone.View {
  /**
   * CSS display value when the element is visible.
   */
  display = 'flex';

  get className() {
    return 'chart-list-item';
  }

  constructor(options) {
    super(options);

    this.children = createElements(
      options.elements,
      this.options.onSelectChart,
      this.options.isElementDisabled
    );

    // Create search text which omits any HTML.
    const stripEl = document.createElement('DIV');
    stripEl.innerHTML = this.options.name;
    this.nameTokens = stripEl.textContent.toLowerCase().split(' ');
  }

  /**
   * Searches the item for the provided text. The element will be visible if the text matches,
   * invisible if not.
   *
   * Returns true if the text matched, false otherwise.
   */
  performSearch(searchTokens) {
    if (searchTokens.length === 0 || search(searchTokens, this.nameTokens)) {
      this.show(true);
      return true;
    }

    // If the item doesn't match, test the children. If any of those match
    let childShown = false;

    this.children.forEach((el) => (childShown = el.performSearch(searchTokens) || childShown));

    if (childShown) {
      this.show();
      return true;
    }

    this.hide();
    return false;
  }

  /**
   * Shows the element but does not show children unless showChildren is true.
   */
  show(showChildren) {
    this.el.style.display = this.display;

    if (showChildren) {
      for (const child of this.children) {
        child.show(true);
      }
    }
  }

  /**
   * Hides the element and children.
   */
  hide() {
    this.el.style.display = 'none';
  }
}

class ChartListItem extends ListItem {
  events = { click: 'onClick' };

  get className() {
    return 'chart-list-item chart';
  }

  render() {
    super.render();

    this.delegateEvents(this.events);

    // We know the HTML provided is safe to use.
    this.$el.append(
      $('<img width="50" height="30" alt="" />').attr('src', this.options.image_url),
      $('<span class="chart-name" />').html(this.options.name)
    );

    this.options.isElementDisabled(this.options.key);

    if (this.options.isElementDisabled(this.options.key)) {
      this.$el.addClass('disabled');
    }

    return this.el;
  }

  onClick(event) {
    event.preventDefault();

    if (this.options.isElementDisabled(this.options.key)) {
      return;
    }

    if (this.options.output_element_type_name === 'preset') {
      App.settings.save({ locked_charts: this.options.items }).done(function () {
        location.reload();
      });

      return;
    }

    this.options.onSelectChart(this.options.key);
  }
}

/**
 * Represents a group or sub-group header and child elements.
 */
class GroupListItem extends ListItem {
  /**
   * The tag used to wrap the item name or content (except any child elements).
   */
  innerTagName() {
    return this.options.type === 'group' ? 'H1' : 'H2';
  }

  get className() {
    return 'chart-list-item group';
  }

  // Renders the group name and any child elements.
  render() {
    this.delegateEvents(this.events);

    const innerEl = document.createElement(this.innerTagName());
    innerEl.innerHTML = this.options.name;

    this.el.append(innerEl);

    if (!this.options.key) {
      innerEl.classList.add('empty');
    }

    let childrenContainer = this.el;

    if (this.children && !this.children[0].options.type) {
      // Wrap charts inside an extra div to allow use to fine-tune the margins.
      childrenContainer = document.createElement('DIV');
      childrenContainer.classList.add('charts');
      this.el.append(childrenContainer);
    }

    for (const child of this.children) {
      childrenContainer.append(child.render());
    }

    return this.el;
  }
}

/**
 * Renders the search form.
 */
class SearchView extends Backbone.View {
  get events() {
    return {
      'input input': 'onInput',
      'keyup input': 'onKeyUp',
    };
  }

  get className() {
    return 'search';
  }

  render() {
    this.inputEl = $('<input name="q" type="search" />').attr(
      'placeholder',
      `${I18n.t('chart_picker.search_for_a_chart')}...`
    )[0];

    this.el.append($('<span class="fa fa-search" />')[0], this.inputEl);

    return this.el;
  }

  onInput(event) {
    this.options.onInput?.(event.target.value.trim());
  }

  onKeyUp(event) {
    if (event.key == 'Escape') {
      event.preventDefault();
      this.options.onEscape?.();
    }
  }

  reset() {
    this.inputEl.value = '';
  }

  focus() {
    this.inputEl.focus();
  }
}

/**
 * Shown when the search text provided by the user has no matching charts.
 */
class NoMatchesView extends Backbone.View {
  get events() {
    return { 'click button': 'onReset' };
  }

  get className() {
    return 'no-matches';
  }

  render() {
    this.$el.append(
      $('<span class="wrap" />').append(
        I18n.t('chart_picker.no_matches'),
        ' &ndash; ',
        $('<button />').text(I18n.t('chart_picker.reset_search'))
      )
    );

    return this.el;
  }

  onReset() {
    this.options.onReset?.();
  }

  show() {
    this.el.style.display = 'block';
  }

  hide() {
    this.el.style.display = 'none';
  }
}

export default class ChartListView extends Backbone.View {
  /**
   * Fetches the data from the API, returning a jQuery.Deferred which yields the data. Repeat calls
   * return the same Deferred and don't hit the API again.
   */
  static fetchData() {
    this.fetchDeferred ||= $.getJSON('/output_elements');
    return this.fetchDeferred;
  }

  /**
   * Renders the ChartListView inside a FancyBox popup.
   *
   * @param {function} onSelectChart
   *   A callback function which is fired when the user selects a chart. Yields the chart key.
   * @param {function} isElementDisabled
   *   A function called for each element with the element key. The function should return true or
   *   false indicating whether the element is disabled. This only affects list elements which
   *   represent charts, not groups.
   */
  render(onSelectChart, isElementDisabled) {
    // Called whenever the user selects a chart.
    const onSelect = (chartId) => {
      $.fancybox.close();
      onSelectChart && onSelectChart(chartId);
    };

    isElementDisabled ||= () => false;

    this.elements = createElements(this.options.data, onSelect, isElementDisabled);

    this.selectChartsEl = $('<div class="chart-selection" />');

    this.noMatches = new NoMatchesView({ onReset: this.reset });
    this.noMatches.hide();

    this.searchView = new SearchView({
      onEscape: () => $.fancybox.close(),
      onInput: (text) => this.performSearch(text),
    });

    this.el.append(this.searchView.render());

    for (const element of this.elements) {
      this.selectChartsEl.append(element.render());
    }

    this.el.append(this.selectChartsEl[0]);
    this.el.append(this.noMatches.render());

    $.fancybox.open({
      autoSize: false,
      type: 'ajax',
      content: '<div id="select-charts-dialog"></div>',
      width: 930,
      height: window.innerHeight - 100,
      padding: 0,
    });

    document.querySelector('#select-charts-dialog').innerHTML = '';
    document.querySelector('#select-charts-dialog').append(this.el);

    this.searchView.focus();

    return this.el;
  }

  /**
   * Performs a search recursively through all elements and their children. Those which match the
   * search term will be visible, those that don't will be hidden.
   */
  performSearch(text) {
    let anyMatches = false;
    const searchTokens = text.toLowerCase().trim().split(' ');

    this.elements.forEach((el) => (anyMatches = el.performSearch(searchTokens) || anyMatches));

    if (anyMatches) {
      this.noMatches.hide();
    } else {
      this.noMatches.show();
    }
  }

  /**
   * Empties the search field and shows all elements.
   */
  reset = () => {
    this.searchView?.reset();
    this.searchView?.focus();
    this.noMatches?.hide();
    this.elements.forEach((el) => el.show(true));
  };
}
