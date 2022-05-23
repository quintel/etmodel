// vim: set sw=4 ts=4 et:

(function ($, _) {
    "use strict";

    // Event names used for setting up drag events.
    var DRAG_E           = 'mousemove',
        DRAG_START_E     = 'mousedown',
        DRAG_END_E       = 'mouseup',
        IS_TOUCH_ENABLED =  false;

    if ('ontouchstart' in document.documentElement) {
        DRAG_E           = 'touchmove';
        DRAG_START_E     = 'touchstart';
        DRAG_END_E       = 'touchend';
        IS_TOUCH_ENABLED =  true;
    }

    /**
     * Given an event, returns the horizontal location on the page on which
     * the event occurred.
     */
    function locationOfEvent (event) {
        var oEvent = event.originalEvent;

        if (oEvent.touches && oEvent.touches.length) {
            return oEvent.touches[0].pageX;
        } else if (oEvent.changedTouches && oEvent.changedTouches.length) {
            return oEvent.changedTouches[0].pageX;
        }

        return event.pageX;
    }

    /**
     * Determines to what minimum and maximum value the slider should be
     * drawn. Defaults to whatever minimum and maximum the user gave, but will
     * prefer an explicit "drawTo" option is one is provided.
     */
    function drawToOpts (drawTo, min, max) {
        drawTo = drawTo || {};

        return {
            left:  _.has(drawTo, 'left')  ? drawTo.left  : min,
            right: _.has(drawTo, 'right') ? drawTo.right : max
        };
    }

    /**
     * When progressively enhancing an HTML input, this Quinn object's
     * "wrapper", which is initially the input element, will be swapped with a
     * new <div/> which can be used as the Quinn element.
     */
    function createReplacementEl (element) {
        return $('<div />').css({
            'width':   element.outerWidth(),
            'margin':  element.css('margin'),
            'display': 'inline-block'
        });
    }

    /**
     * When progressively-enhancing an HTML input, we need to use its min/max
     * values. This will read them, falling back to data- attributes, or the
     * Quinn defaults.
     */
    function readInputAttribute (el, quinn, attribute) {
        var value = el.attr(attribute) || el.data('quinn-' + attribute);

        return (value ? parseFloat(value) : quinn.options[attribute]);
    }

    /**
     * ## Quinn
     *
     * Quinn is the main slider class, and handles setting up the slider UI,
     * the element events, values, etc.
     *
     * `wrapper` is expected to be a DOM Element wrapped in a jQuery instance.
     * The slider will be placed into the wrapper element, respecting it's
     * width, padding etc.
     */
    function Quinn (wrapper, options) {
        var opts;

        _.bindAll(this, 'clickBar', 'startDrag', 'drag', 'endDrag',
                        'handleKeyboardEvent', 'enableKeyboardEvents',
                        'disableKeyboardEvents');

        this.wrapper        = wrapper;
        this.options = opts = _.extend({}, Quinn.defaults, options);
        this.callbacks      = {};

        this.disabled       = false;
        this.activeHandle   = null;
        this.previousValue  = null;

        if (wrapper.is('input')) {
            this.enhance(wrapper);
        }

        this.drawTo         = drawToOpts(opts.drawTo, opts.min, opts.max);

        this.model          = new Model(this, this.options.strict);
        this.renderer       = new this.options.renderer(this);

        this.keyFloodTimer  = null;

        this.wrapperWidth   = 0;
        this.wrapperOffset  = 0;

        this.on('setup',  opts.setup);
        this.on('begin',  opts.begin);
        this.on('drag',   opts.drag);
        this.on('change', opts.change);
        this.on('abort',  opts.abort);

        if (_.isFunction(this.renderer.render)) {
            this.renderer.render();
        }

        if (opts.disable === true) {
            this.disable();
        }

        // Finish off by triggering the setup callback.
        this.trigger('setup', this.model.value);
    }

    // The current Quinn version.
    Quinn.VERSION = '1.2.2';

    // ### Event Handling

    /**
     * ### on
     *
     * Binds a `callback` to be run whenever the given `event` occurs. Returns
     * the Quinn instance permitting chaining.
     */
    Quinn.prototype.on = function (event, callback) {
        if (_.isString(event) && _.isFunction(callback)) {
            if (! this.callbacks[event]) {
                this.callbacks[event] = [];
            }

            this.callbacks[event].push(callback);
        }

        return this;
    };

    /**
     * ### trigger
     *
     * Runs the callbacks of the given evengt type.
     *
     * If any of the callbacks return false, other callbacks will not be run,
     * and trigger will return false; otherwise true is returned.
     */
    Quinn.prototype.trigger = function (event, value) {
        var callbacks = this.callbacks[event] || [],
            i = 0,
            callback;

        if (value === void 0) {
            value = this.value;
        }

        while (callback = callbacks[i++]) {
            if (callback(value, this) === false) {
                return false;
            }
        }

        return true;
    };

    // ## Values, and Domain Logic

    /**
     * ### enable
     *
     * Enables the slider so that a user may change its value. Triggers the
     * "enabled" event unless the instance was already enabled.
     */
    Quinn.prototype.enable = function () {
        if (this.disabled) {
            this.disabled = false;
            this.trigger('enabled');
        }
    };

    /**
     * ### disable
     *
     * Disables the slider so that a user may not change its value. Triggers
     * the "disabled" event unless the instance was already disabled.
     */
    Quinn.prototype.disable = function () {
        if (! this.disabled) {
            this.disabled = true;
            this.trigger('disabled');
        }
    };

    /**
     * ### setValue
     *
     * Updates the value of the slider to `newValue`. If the `animate`
     * argument is truthy, the change in value will be animated when updating
     * the slider position. The drag callback may be skipped if `silent` is
     * true.
     */
    Quinn.prototype.setValue = function (newValue, animate, silent) {
        if (this.start()) {
            if (this.setTentativeValue(newValue, animate, silent) !== false) {
                this.resolve();
            } else {
                this.reject();
            }
        }

        return this.model.value;
    };

    /**
     * ### setTentativeValue
     *
     * Used internally to set the model value while ensuring that the
     * necessary callbacks are fired.
     *
     * See `setValue`.
     */
    Quinn.prototype.setTentativeValue = function (newValue, animate, silent) {
        var preDragValue = this.model.value,
            prevScalar   = null,
            nextScalar   = null,
            scalar;

        if (newValue === undefined || newValue === null) {
            return false;
        }

        // If the slider is a range (more than one value), but only a number
        // was given, we need to alter the given value so that we set the
        // other values also.
        if (this.model.values.length > 1 && _.isNumber(newValue)) {
            if (this.activeHandle === null) {
                // Without an active handle, we don't know which value we are
                // supposed to set.
                return false;
            }

            scalar   = this.model.sanitizeValue(newValue);
            newValue = _.clone(this.model.values);

            // Ensure that the handle doesn't "cross over" a higher or
            // lower handle.

            prevScalar = newValue[this.activeHandle - 1];
            nextScalar = newValue[this.activeHandle + 1];

            if (prevScalar !== null && scalar <= prevScalar) {
                scalar = prevScalar + this.options.step;
            }

            if (nextScalar !== null && scalar >= nextScalar) {
                scalar = nextScalar - this.options.step;
            }

            newValue[this.activeHandle] = scalar;
        }

        newValue = this.model.setValue(newValue);

        if (newValue === false ||
                (! silent && ! this.trigger('drag', newValue))) {

            this.model.setValue(preDragValue);

            // If the drag callback failed, we need to send another drag
            // event so that the developer has the chance to respond.
            (newValue !== false && this.trigger('drag', preDragValue));

            return false;
        }

        this.trigger('redraw', animate);

        return newValue;
    };

    /**
     * ### stepUp
     *
     * Increases the value of the slider by `step`. Does nothing if the slider
     * is alredy at its maximum value.
     *
     * The optional argument is an integer which indicates the number of steps
     * by which to increase the value.
     *
     * Returns the new slider value
     */
    Quinn.prototype.stepUp = function (count, animate, tentative) {
        var func = (tentative ? this.setTentativeValue : this.setValue);

        if (this.model.values.length > 1) {
            // Cannot step a range-based slider.
            return this.model.value;
        }

        return _.bind(func, this)(
            this.model.value + this.model.step * (count || 1), animate);
    };

    /**
     * ### stepDown
     *
     * Decreases the value of the slider by `step`. Does nothing if the slider
     * is alredy at its minimum value.
     *
     * The optional argument is an integer which indicates the number of steps
     * by which to decrease the value.
     *
     * Returns the new slider value
     */
    Quinn.prototype.stepDown = function (count, animate, tentative) {
        return this.stepUp(-(count || 1), animate, tentative);
    };

    /**
     * ### start
     *
     * Tells the Quinn instance that the user is about to make a change to the
     * slider value. The calling function should check the return value of
     * start -- if false, no changes are permitted to the slider.
     */
    Quinn.prototype.start = function () {
        if (this.disabled === true || ! this.trigger('begin')) {
            return false;
        }

        this.previousValue = this.model.value;

        // These attributes are cached so that we don't have to look them up
        // every time the user drags the handle.
        this.wrapperWidth  = this.wrapper.width();
        this.wrapperOffset = this.wrapper.offset().left;

        return true;
    };

    /**
     * ### resolve
     *
     * Tells the Quinn instance that the user has finished making their
     * changes to the slider and that the new value should be retained.
     */
    Quinn.prototype.resolve = function () {
        this.deactivateActiveHandle();

        if (_.isEqual(this.previousValue, this.model.value)) {
            // The user reset the slider back to where it was.
            this.reject();
            return false;
        }

        /* Run the change callback; if the callback returns false then we
         * revert the slider change, and restore everything to how it was
         * before. Note that reverting the change will also fire an change
         * event when the value is reverted.
         */
        if (! this.trigger('change', this.model.value)) {
            this.setTentativeValue(this.previousValue);
            this.reject();

            return false;
        }

        this.previousValue = null;
    };

    /**
     * ### reject
     *
     * Aborts a slider change.
     */
    Quinn.prototype.reject = function () {
        this.previousValue = null;
        this.deactivateActiveHandle();

        return this.trigger('abort');
    };

    /**
     * ### valueFromMouse
     *
     * Determines the value of the slider at the position indicated by the
     * mouse cursor.
     */
    Quinn.prototype.valueFromMouse = function (mousePosition) {
        var percent = this.positionFromMouse(mousePosition),
            delta   = this.drawTo.right - this.drawTo.left;

        return this.drawTo.left + delta * percent;
    };

    /**
     * ### positionFromMouse
     *
     * Determines how far along the bar the mouse cursor is as a fraction of
     * the bar's width.
     *
     * TODO Cache the width and offset when the drag operation begins.
     */
    Quinn.prototype.positionFromMouse = function (mousePosition) {
        var maxRight = this.wrapperOffset + this.wrapperWidth,
            barPosition;

        if (mousePosition < this.wrapperOffset) {
            // Mouse is to the left of the bar.
            barPosition = 0;
        } else if (mousePosition > maxRight) {
            // Mouse is to the right of the bar.
            barPosition = this.wrapperWidth;
        } else {
            barPosition = mousePosition - this.wrapperOffset;
        }

        return barPosition / this.wrapperWidth;
    };

    // ## User Interaction

    /**
     * ### startDrag
     *
     * Begins a drag event which permits a user to move the slider handle in
     * order to adjust the slider value.
     *
     * When `skipPreamble` is true, startDrag will not run `start()` on the
     * assumption that it has already been run (see `clickBar`).
     */
    Quinn.prototype.startDrag = function (event, skipPreamble) {
        // Only enable dragging when the left mouse button is used.
        if (! IS_TOUCH_ENABLED && event.which !== 1) {
            return true;
        }

        if (! skipPreamble && ! this.start()) {
            return false;
        }

        this.activateHandleWithEvent(event);

        // These events are bound for the duration of the drag operation and
        // keep track of the value changes made, with the events being removed
        // when the mouse button is released.
        $(document).
            on(DRAG_END_E + '.quinn', this.endDrag).
            on(DRAG_E     + '.quinn', this.drag).

            // The mouse may leave the window while dragging, and the mouse
            // button released. Watch for the mouse re-entering, and see what
            // the button is doing.
            on('mouseenter.quinn', this.endDrag);

        return false;
    };

    /**
     * ### drag
     *
     * Bound to the mousemove event, alters the slider value while the user
     * contiues to hold the left mouse button.
     */
    Quinn.prototype.drag = function (event) {
        this.setTentativeValue(
            this.valueFromMouse(locationOfEvent(event)), false);

        return event.preventDefault();
    };

    /**
     * ### endDrag
     *
     * Run when the user lifts the mouse button after completing a drag.
     */
    Quinn.prototype.endDrag = function (event) {
        // Remove the events which were bound in `startDrag`.
        $(document).
            off(DRAG_END_E + '.quinn').
            off(DRAG_E + '.quinn').
            off('mouseenter.quinn');

        this.resolve();

        return event.preventDefault();
    };

    /**
     * ### clickBar
     *
     * Event handler which is used when the user clicks part of the slider bar
     * to instantly change the value.
     */
    Quinn.prototype.clickBar = function (event) {
        // Ignore the click if the left mouse button wasn't used.
        if (! IS_TOUCH_ENABLED && event.which !== 1) {
            return true;
        }

        if (this.start()) {
            this.activateHandleWithEvent(event);
            this.setTentativeValue(
                this.valueFromMouse(locationOfEvent(event)));
            this.startDrag(event, true);
        }

        return event.preventDefault();
    };

    /**
     * Given a click or drag event, determines which model "value" is closest
     * to the clicked location and tells the view to activate the handle.
     * Does nothing if a handle is already active.
     */
    Quinn.prototype.activateHandleWithEvent = function (event) {
        var value, closestValue, handleIndex;

        if (this.activeHandle) {
            return false;
        }

        value = this.valueFromMouse(locationOfEvent(event));

        closestValue = _.min(this.model.values, function (handleValue) {
            return Math.abs(handleValue - value);
        });

        handleIndex = _.indexOf(this.model.values, closestValue);

        if (handleIndex !== -1) {
            this.activeHandle = handleIndex;
            this.trigger('handleOn', this.activeHandle);
        }
    };

    /**
     * Deactivates the currently active handle. Does nothing if no handle is
     * active.
     */
    Quinn.prototype.deactivateActiveHandle = function () {
        if (this.activeHandle !== null && this.activeHandle !== -1) {
            this.trigger('handleOff', this.activeHandle);
            this.activeHandle = null;
        }
    };

    /**
     * When an handle is focused, allows left/right to change the value.
     */
    Quinn.prototype.enableKeyboardEvents = function (event) {
        $(event.target).on('keydown', this.handleKeyboardEvent);
        $(event.target).on('keyup',   this.handleKeyboardEvent);
    };

    /**
     * Unsets keyboard event handlers after the handle is blurred.
     */
    Quinn.prototype.disableKeyboardEvents = function (event) {
        $(event.target).off('keydown', this.handleKeyboardEvent);
        $(event.target).off('keyup',   this.handleKeyboardEvent);
    };

    /**
     * Receives events from the keyboard and adjusts the Quinn value.
     */
    Quinn.prototype.handleKeyboardEvent = function (event) {
        if (event.type === 'keydown') {
            if (this.keyFloodTimer) {
                window.clearTimeout(this.keyFloodTimer);
                this.keyFloodTimer = null;
            }

            if (this.previousValue == null && ! this.start()) {
                return false;
            }
        } else if (event.type === 'keyup') {
            if (this.previousValue != null) {
                if (this.options.keyFloodWait) {
                    // Prevent multiple successive keydowns from repeatedly
                    // triggering resolve.
                    this.keyFloodTimer = window.setTimeout(
                        _.bind(this.resolve, this),
                        this.options.keyFloodWait);
                } else {
                    this.resolve();
                }
            }

            return true;
        }

        switch (event.which) {
            case 33: // Page up.
                this.stepUp(10, false, true); break;
            case 34: // Page down.
                this.stepDown(10, false, true); break;
            case 37: // Left arrow.
            case 40: // Down arrow.
                if (event.metaKey) {
                    this.setTentativeValue(this.model.minimum, false);
                } else {
                    this.stepDown(event.altKey ? 10 : 1, false, true);
                }
                break;
            case 39: // Right arrow.
            case 38: // Up arrow.
                if (event.metaKey) {
                    this.setTentativeValue(this.model.maximum, false);
                } else {
                    this.stepUp(event.altKey ? 10 : 1, false, true);
                }
                break;
            default:
                return true;
        }

        event.preventDefault();
    };

    /**
     * Used during initialization to progressively-enhance an existing HTML
     * input, instead of simply drawing into a <div/>.
     *
     * Afters the Quinn options, renders the replacement elements in the DOM,
     * and sets up events to send the value back-and-forth between Quinn and the
     * original input element.
     */
    Quinn.prototype.enhance = function (element) {
        this.options.disabled = element.attr('disabled');
        this.options.step     = readInputAttribute(element, this, 'step');
        this.options.value    = readInputAttribute(element, this, 'value');
        this.options.min      = readInputAttribute(element, this, 'min');
        this.options.max      = readInputAttribute(element, this, 'max');

        this.wrapper = createReplacementEl(element).insertAfter(element.hide());

        this.on('change', function (value) { element.val(value) });

        element.on('change', _.bind(function () {
            this.setValue(element.val());
        }, this));
    };

    /**
     * ## Model
     *
     * Holds the current Quinn value, ensures that the value set is valid
     * (within the `range` bounds, one of the `only` values, etc).
     */
    function Model (quinn, initiallyStrict) {
        var opts, initialValue, length, i;

        this.options = opts = quinn.options;
        this.step    = opts.step;
        this.only    = opts.only;
        this.values  = [];

        /* The minimum and maximum need to be "fixed" so that they are a
         * multiple of the "step" option. For example, if given a step of 5
         * then we must round a minimum value of 2 up to 5, and a maximum
         * value of 97 down to 95.
         *
         * Note that values are always rounded so that they stay within the
         * given minimum and maximum range. 2 cannot be rounded down to 0,
         * since that is lower than the value provided by the user.
         *
         * TODO Provided this.min and this.max are set, isn't it possible
         *      to just use sanitizeValue?
         */

        this.minimum = this.roundToStep(opts.min);
        this.maximum = this.roundToStep(opts.max);

        if (this.minimum < opts.min) {
            this.minimum += this.step;
        }

        if (this.maximum > opts.max) {
            this.maximum -= this.step;
        }

        /* Determine the initial value of the slider. Prefer an explicitly set
         * value, whether a scalar or an array. If no value is provided by the
         * developer, instead fall back to using the minimum.
         */

        if (opts.value === undefined || opts.value === null) {
            initialValue = this.minimum;
        } else if (_.isArray(opts.value)) {
            initialValue = opts.value;
        } else {
            initialValue = [ opts.value ];
        }

        for (i = 0, length = initialValue.length; i < length; i++) {
            this.values[i] = null;
        }

        this.setValue(initialValue, initiallyStrict);
    }

    /**
     * An internal method which sets the value of the slider during a drag
     * event. `setValue` should be called only after `start` in the Quinn
     * instance.
     *
     * Only when `resolve` is called is the value considered final. If
     * `reject` is called, the tentative value is discarded and the
     * previous "good" value is restored.
     *
     * The new value will be returned (which may differ slightly from the
     * value you set, if it had to be adjusted to fit the step option, or stay
     * within the minimum / maximum range). The method will return false if
     * the value you set resulted in no changes.
     */
    Model.prototype.setValue = function (newValue, strict) {
        var originalValue = this.values, length, i;

        if (! _.isArray(newValue)) {
            newValue = [ newValue ];
        } else {
            // Don't mutate the original array.
            newValue = _.clone(newValue);
        }

        for (i = 0, length = newValue.length; i < length; i++) {
            newValue[i] = this.sanitizeValue(newValue[i], strict);
        }

        if (_.isEqual(newValue, originalValue)) {
            return false;
        }

        this.value = this.values = newValue;

        if (this.values.length === 1) {
            // When the slider represents only a single value, instead of
            // setting an array as the value, just use the number.
            this.value = newValue[0];
        }

        return this.value;
    };

    /**
     * ### roundToStep
     *
     * Given a number, rounds it to the nearest step.
     *
     * For example, if options.step is 5, given 4 will round to 5. Given
     * 2 will round to 0, etc. Does not take account of the minimum and
     * maximum range options.
     */
    Model.prototype.roundToStep = function (number) {
        var multiplier = 1 / this.step,
            rounded    = Math.round(number * multiplier) / multiplier;

        if (_.isArray(this.only)) {
            rounded = _.min(this.only, function (value) {
                return Math.abs(value - number);
            });
        }

        if (rounded > this.maximum) {
            return rounded - this.step;
        } else if (rounded < this.minimum) {
            return rounded + this.step;
        }

        return rounded;
    };

    /**
     * ### sanitizeValue
     *
     * Given a numberic value, snaps it to the nearest step, and ensures that
     * it is within the selectable minima and maxima.
     */
    Model.prototype.sanitizeValue = function (value, strict) {
        if (strict !== false) {
            value = this.roundToStep(value);
        }

        if (value > this.maximum) {
            return this.maximum;
        } else if (value < this.minimum) {
            return this.minimum;
        }

        return value;
    };

    /**
     * ## Renderer
     *
     * Handles creation of the DOM nodes used by Quinn, as well as redrawing
     * those elements when the slider value is changed.
     *
     * You may write your own renderer class and provide it to Quinn using the
     * `renderer: myRenderer` option.
     *
     * Your class needs to define only two public methods:
     *
     * render:
     *   Creates the DOM elements for displaying the slider, and inserts them
     *   into the tree.
     *
     * redraw:
     *   Alters DOM elements (normally CSS) so that the visual representation
     *   of the slider matches the value.
     */
    Quinn.Renderer = function (quinn) {
        _.bindAll(this, 'render', 'redraw');

        var self = this;

        this.quinn    = quinn;
        this.model    = quinn.model;
        this.wrapper  = quinn.wrapper;
        this.options  = quinn.options;
        this.handles  = [];
        this.lastDraw = [];

        quinn.on('redraw', this.redraw);

        quinn.on('handleOn', function (handleIndex) {
            self.handles[handleIndex].addClass('active');
        });

        quinn.on('handleOff', function (handleIndex) {
            self.handles[handleIndex].removeClass('active');
        });

        quinn.on('enabled', function () {
            self.wrapper.removeClass('disabled');

            if (self.options.disabledOpacity !== 1.0) {
                self.wrapper.css('opacity', 1.0);
            }
        });

        quinn.on('disabled', function () {
            self.wrapper.addClass('disabled');

            if (self.options.disabledOpacity !== 1.0) {
                self.wrapper.css('opacity', self.options.disabledOpacity);
            }
        });
    };

    /**
     * ### render
     *
     * Quinn is initialized with an empty wrapper element; render adds the
     * necessary DOM elements in order to display the slider UI.
     *
     * render() is called automatically when creating a new Quinn instance.
     */
    Quinn.Renderer.prototype.render = function () {
        var i, length;

        this.width = this.wrapper.width();

        function addRoundingElements (element) {
            element.append($('<div class="left" />'));
            element.append($('<div class="main" />'));
            element.append($('<div class="right" />'));
        }

        this.bar      = $('<div class="bar" />');
        this.deltaBar = $('<div class="delta-bar" />');

        if (this.model.values.length > 1) {
            this.wrapper.addClass('multiple');
        }

        addRoundingElements(this.bar);

        if (this.model.values.length <= 2) {
            addRoundingElements(this.deltaBar);
            this.bar.append(this.deltaBar);
        }

        this.wrapper.html(this.bar);
        this.wrapper.addClass('quinn');

        // Add each of the handles to the bar, and bind the click events.
        for (i = 0, length = this.model.values.length; i < length; i++) {
            this.handles[i] = $('<span class="handle" tabindex="0" role="slider"></span>')
                .attr('aria-valuemin', this.model.minimum)
                .attr('aria-valuemax', this.model.maximum)
                .attr('aria-valuenow', this.model.values[i]);

            this.handles[i].on(DRAG_START_E, this.quinn.startDrag);

            if (this.quinn.model.values.length < 2) {
                this.handles[i].on('focus', this.quinn.enableKeyboardEvents);
                this.handles[i].on('blur', this.quinn.disableKeyboardEvents);
            }

            this.bar.append(this.handles[i]);
        }

        // Finally, these events are triggered when the user seeks to
        // update the slider.
        this.wrapper.on(DRAG_START_E, this.quinn.clickBar);

        this.barHeight = this.bar.height();

        // If the handles have left and right margins, it indicates that the
        // user wants the handle to "overhang" the edges of the bar. We have to
        // account for this when positioning the handles.
        this.handleOverhang =
            parseInt(this.handles[0].css('margin-left'), 10) +
            parseInt(this.handles[0].css('margin-right'), 10);

        this.redraw(false);
    };

    /**
     * ### redraw
     *
     * Moves the slider handle and the delta-bar background elements so that
     * they accurately represent the value of the slider.
     */
    Quinn.Renderer.prototype.redraw = function (animate) {
        var self = this;

        if (animate !== false) {
            animate = true;
        }

        _.each(this.model.values, function (value, i) {
            var handle, position;

            if (value === self.lastDraw[i]) {
                return true;
            }

            handle   = self.handles[i].stop();
            position = self.position(value) + 'px';

            handle.attr('aria-valuenow', value);

            if (animate && self.options.effects) {
                handle.animate({ left: position }, {
                    duration: self.options.effectSpeed,
                    step:     self.redrawDeltaBarInStep(handle)
                });
            } else {
                handle.css('left', position);
                self.redrawDeltaBar(value, handle);
            }
        });

        this.lastDraw = _.clone(this.model.values);
    };

    /**
     * ### redrawDeltaBar
     *
     * Positions the blue delta bar so that it originates at a position where
     * the value 0 is. Accepts a `value` argument so that it may be used
     * within a `step` callback in a jQuery `animate` call.
     */
    Quinn.Renderer.prototype.redrawDeltaBar = function (value, handle) {
        var left = null,
            right = null,
            drawAt = parseInt(handle.css('left'), 10) + this.barHeight;

        this.deltaBar.stop(true);

        if (this.model.values.length > 1) {
            if (handle) {
                if (handle === this.handles[0]) {
                    left = drawAt;
                } else {
                    right = drawAt;
                }
            } else {
                left  = value[0];
                right = value[1];
            }
        } else if (value < 0) {
            // position with the left edge underneath the handle, and the
            // right edge at 0
            left  = drawAt;
            right = this.position(0, true);
        } else {
            // position with the right edge underneath the handle, and the
            // left edge at 0
            right = drawAt;
            left  = this.position(0, true);
        }

        if (left !== null) {
            this.deltaBar.css('left', left);
        }

        if (right !== null) {
            right = this.width - right;
            this.deltaBar.css('right', right);
        }
    };

    /**
     * ### redrawDeltaBarInStep
     *
     * Draws the delta bar from within the step function during a jQuery
     * animation.
     */
    Quinn.Renderer.prototype.redrawDeltaBarInStep = function (handle) {
        if (! this.deltaBar) {
            return function() {};
        }

        var min    = this.quinn.drawTo.left,
            max    = this.quinn.drawTo.right,
            adjust = Math.ceil(this.deltaBar.height() / 2),
            self   = this;

        return function (now) {
            now = (now + adjust) / self.width;

            // "now" is the current "left" position of the handle.
            // Convert that to the equivalent value. For example,
            // if the slider is 0->200, and now is 20, the
            // equivalent value is 40.
            self.redrawDeltaBar(now * (max - min) + min, handle);

            return true;
        };
    };

    /**
     * ### position
     *
     * Given a slider value, returns the position in pixels where the value is
     * on the slider bar. For example, in a 200px wide bar whose values are
     * 1->100, the value 20 is found 40px from the left of the bar.
     */
    Quinn.Renderer.prototype.position = function (value, ignoreOverhang) {
        var delta    = this.quinn.drawTo.right - this.quinn.drawTo.left,
            maxRight = this.width,
            position;

        if (! ignoreOverhang) {
            // When using the position function for drawing the delta bar, we
            // need to account for the "overhang" margin of the handle.
            maxRight -= this.handles[0].width() + this.handleOverhang;
        }

        position = ((value - this.quinn.drawTo.left) / delta) * maxRight;

        if (position < 0) {
            return 0;
        } else if (position > maxRight) {
            return maxRight;
        }

        return Math.round(position);
    };

    /**
     * ### Options
     *
     * Default option values which are used when the user does not explicitly
     * provide them.
     */
    Quinn.defaults = {
        // The minimum value which may be selected by a user.
        min: 0,

        // The maximum value which may be selected by a user.
        max: 100,

        // If you wish the slider to be drawn so that it is wider than the
        // range of values which a user may select, supply the values as a
        // two-element array.
        drawTo: null,

        // The "steps" by which the selectable value increases. For example,
        // when set to 2, the default slider will increase in steps from 0, 2,
        // 4, 8, etc.
        step: 1,

        // The initial value of the slider. null = use the lowest permitted
        // value.
        value: null,

        // Snaps the initial value to fit with the given "step" value. For
        // example, given a step of 0.1 and an initial value of 1.05, the
        // value will be changes to fit the step, and rounded to 1.1.
        //
        // Notes:
        //
        //  * Even with `strict` disabled, initial values which are outside
        //    the given `min` and `max` will still be changed to fit within
        //    the permitted range.
        //
        //  * The `strict` setting affects the *initial value only*.
        strict: true,

        // Restrics the values which may be chosen to those listed in the
        // `only` array.
        only: null,

        // Disables the slider when initialized so that a user may not change
        // it's value.
        disable: false,

        // By default, Quinn fades the opacity of the slider to 50% when
        // disabled, however this may not work perfectly with older Internet
        // Explorer versions when using transparent PNGs. Setting this to 1.0
        // will tell Quinn not to fade the slider when disabled.
        disabledOpacity: 0.5,

        // If using Quinn on an element which isn't attached to the DOM, the
        // library won't be able to determine it's width; supply it as a
        // number (in pixels).
        width: null,

        // If using Quinn on an element which isn't attached to the DOM, the
        // library won't be able to determine the width of the handle; suppl
        // it as a number (in pixels).
        handleWidth: null,

        // A callback which is run when changing the slider value. Additional
        // callbacks may be added with Quinn::on('drag').
        //
        // Arguments:
        //   number: the altered slider value
        //   Quinn:  the Quinn instance
        //
        drag: null,

        // Run after the user has finished making a change.
        //
        // Arguments:
        //   number: the new slider value
        //   Quinn:  the Quinn instance
        //
        change: null,

        // Run once after the slider has been constructed.
        //
        // Arguments:
        //   number: the current slider value
        //   Quinn:  the Quinn instance
        //
        setup: null,

        // An optional class which is used to render the Quinn DOM elements
        // and redraw them when the slider value is changed. This should be
        // the class; Quinn will create the instance, passing the wrapper
        // element and the options used when $(...).quinn() is called.
        //
        // Arguments:
        //   Quinn:  the Quinn instance
        //   object: the options passed to $.fn.quinn
        //
        renderer: Quinn.Renderer,

        // Enables a slightly delay after keyboard events, in case the user
        // presses the key multiple times in quick succession. False disables,
        // otherwise provide a integer indicating how many milliseconds to
        // wait.
        keyFloodWait: false,

        // When using animations (such as clicking on the bar), how long
        // should the duration be? Any jQuery effect duration value is
        // permitted.
        effectSpeed: 'fast',

        // Set to false to disable all animation on the slider.
        effects: true
    };

    // -----------------------------------------------------------------------

    // The jQuery helper function. Permits $(...).quinn();
    $.fn.quinn = function (options) {
        return $.each(this, function () { new Quinn($(this), options); });
    };

    // Expose Quinn to the world on $.Quinn.
    $.Quinn = Quinn;

})(jQuery, _);
