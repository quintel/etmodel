/* globals $ Backbone */
(function(window) {
  /**
   * Splits a string at the first occurrance of a character.
   */
  function splitAtFirst(string, char) {
    var index = string.indexOf(char);

    if (index === -1) {
      return [string];
    }

    return [string.slice(0, index), string.slice(index + 1)];
  }

  /**
   * Renders an error message when ETEngine threw an exception and returned a
   * backtrace. Highlights lines referring to queries and inputs.
   */
  var TraceView = Backbone.View.extend({
    events: { 'click .expand': 'expand' },

    expand: function() {
      this.options.expanded = true;
      this.$el.empty();
      this.render();
    },

    render: function() {
      var message = this.options.message;
      var split;

      if (message.indexOf('|') !== -1) {
        split = splitAtFirst(message, '|');
      } else {
        split = splitAtFirst(message, '\n');
      }

      if (split[0].match(/\/(present|future)/)) {
        var title = split[0].trim().split('/');

        split[0] = $('<span />').append(
          $('<strong />').text(title[0]),
          '/',
          $('<span />').text(title.slice(1).join('/'))
        );
      } else if (split[0].slice(0, 11) == 'SyntaxError') {
        split[0] = split[0].replace(/in (\w+)/g, 'in <code>$1</code>');
      }

      this.$el.append($('<h2/>').html(split[0]), this.renderTrace(split[1]));

      return this.$el;
    },

    renderTrace: function(trace) {
      if (!trace || trace.trim().length === 0) {
        return null;
      }

      // Query syntax errors separate the error title from the backtrace with a
      // pipe character.
      var split = trace.trim().split(/\n/);
      var expander = null;

      if (!this.options.expanded) {
        expander = $('<span class="expand"/>').html('&middot;&middot;&middot;');
        split = split.slice(0, 8);
      }

      // Highlight substring in the first backtrace lines which refer to queries
      // or inputs.
      split = split.map(function(line) {
        return line.replace(
          /(etsource\/(?:inputs|gqueries).*?):/g,
          '<strong>$1</strong>:'
        );
      });

      return $('<div class="trace"/>').append(
        $('<pre/>').html(split.join('\n')),
        expander
      );
    }
  });

  /**
   * View which hides the ETM interface and shows the user a message describing
   * the error which occurred.
   */
  var ApiErrorView = Backbone.View.extend({
    id: 'api-error',

    events: {
      'click .refresh': function(event) {
        event.preventDefault();
        window.location = window.location; // eslint-disable-line no-self-assign
      },
      'click .hide': function(event) {
        event.preventDefault();

        this.$el.remove();
        $('body').removeClass('has-api-error');
      }
    },

    render: function() {
      this.$el.append(
        $('<h1 />').append(
          $('<span class="fa fa-exclamation-triangle" />'),
          ' ETEngine returned an error'
        )
      );

      this.$el.append(
        $('<div class="buttons" />').append(
          $('<a href="/" class="primary">&larr; Back to the home page</a>'),
          $('<a class="refresh">Refresh and try again</a>').attr(
            'href',
            location.pathname
          ),
          $('<a class="hide">Hide this message</a>').attr('href', '#'),
          $('<a class="open-api">View scenario in ETEngine</a>').attr(
            'href',
            this.options.scenarioURL
          )
        )
      );

      if (
        this.options.status >= 400 &&
        this.options.status < 500 &&
        this.options.responseJSON
      ) {
        this.$el.append(this.renderJSONErrors());
      } else {
        this.$el.append(
          $('<pre class="server-error" />').text(this.options.responseText)
        );
      }

      return this.$el;
    },

    renderJSONErrors: function() {
      return $('<ul/>').append(
        this.options.responseJSON.errors.map(this.renderJSONError)
      );
    },

    renderJSONError: function(message) {
      var li = $('<li/>');

      if (message.indexOf('|') || message.indexOf('\n')) {
        li.append(new TraceView({ message: message }).render());
      } else {
        li.text(message);
      }

      return li;
    }
  });

  window.ApiErrorView = ApiErrorView;
})(window);
