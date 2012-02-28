(function ($) {

    function extractExample (element, exampleID) {
        var code = element.text().
            // replace(/^\$\('\.slider'/, 'el.children(".slider"').
            replace(/\.quinn/,  '.quinnExample').
            replace(/\.slider/, '#' + exampleID + ' .slider').
            replace(/\.value/,  '#' + exampleID + ' .value');

        if (code.length === 0) {
            return function () {};
        } else {
            // Yes, yes. I know.
            return new Function(code);
        }
    }

    function determinePrecision (number) {
        if (_.isNumber(number)) {
            number = number.toString().split('.');
            return number[1] ? number[1].length : 0
        }

        return 0;
    }

    function wrapCallback (cb, precision) {
        return function (newValue, slider) {
            if (_.isFunction(cb) && cb(newValue, slider) === false) {
                return false;
            }

            var precision = determinePrecision(slider.options.step),
                text;

            if (_.isArray(newValue)) {
                text = _.map(newValue, function (val) {
                    return val.toFixed(precision);
                });

                if (newValue.length > 2) {
                    text = text.join(', ');
                } else {
                    text = text.join(' - ');
                }
            } else if (newValue != null) {
                text = newValue.toFixed(precision);
            } else {
                text = '???';
            }

            if (slider.model.maximum === 1.21) {
                text += ' GW';
            }

            slider.wrapper.parents('.example').children('.value').text(text);
        };
    }

    // Wraps around the drag and setup callbacks given in the example to
    // ensure that the value shown in the interactive example is updated as
    // the slider is moved.

    $.fn.quinnExample = function (options) {
        var $this = this;

        options = options || {};

        options = _.extend(options, {
            drag:  wrapCallback(options.drag,  1),
            setup: wrapCallback(options.setup, 1)
        });

        return $this.quinn(options);
    };

    $('p.github').remove();

    $('pre:not(.no-example)').each(function () {
        var $this = $(this),

            // A unique ID used to identify the example.
            exampleID = _.uniqueId('example_'),

            // The options used by the $.fn.quinn call in the example.
            // options = extractOptions(code, exampleID),
            initExample = extractExample($this.find('code'), exampleID),

            // The main DOM node which will replace the pre element.
            exampleEl;

        exampleEl = $('<div class="example" id="' + exampleID + '"></div>');

        exampleEl.append($('<div class="widget"></div>').append(
            $('<div class="slider"></div>')));
        exampleEl.append($('<div class="value"></div>'));
        exampleEl.append($('<pre></pre>').append(
            $('<code class="javascript"></code>').html($this.html())
        ));

        exampleEl.addClass($this[0].className);

        $this.replaceWith(exampleEl);

        initExample();
    });

    $('pre.no-example:not(.css) code').addClass('javascript');


    // Skip syntax highlighting on IE < 9
    if (! $.browser.msie || $.browser.version > 8.0) {
        $('pre.css code').each(function () {
            var $this = $(this).addClass('css');

            $('body').append($('<style type="text/css"></style>').
                text($this.text()));
        });

        // Do highlighting.
        hljs.initHighlightingOnLoad();
    }

})(jQuery);
