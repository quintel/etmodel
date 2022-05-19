window.Analytics = (function () {
  'use strict';

  /**
   * Create a new Analytics instance.
   *
   * @param {function} sender
   *   A function which, when invoked, will send an event to the analytics
   *   endpoint. May be an empty function if you want no events to be sent.
   */
  function Analytics(sender) {
    this.sendEvent = sender || function () {};

    // Only send these events the first time they occur (i.e. notify that user
    // has changed "input_1" the first time it is changed and ignore further
    // changes).
    this.chartAdded = _.memoize(this.chartAdded);
    this.inputChanged = _.memoize(this.inputChanged);
  }

  Analytics.prototype = {
    track: function (scope, type, data) {
      this.sendEvent('send', 'event', scope, type, data);
    },

    chartAdded: function (key) {
      this.track('chart', 'added', key);
    },

    inputChanged: function (key) {
      this.track('input', 'changed', key);
    },

    sendPageView: function (path, title) {
      this.sendEvent('set', {
        page: path,
        title: title,
      });

      this.sendEvent('send', 'pageview');
    },
  };

  return Analytics;
})();
