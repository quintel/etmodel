(function ($, _) {

    // Event names used for setting up drag events.
    var DRAG_E           = 'mousemove',
        DRAG_START_E     = 'mousedown',
        DRAG_END_E       = 'mouseup',
        IS_TOUCH_ENABLED =  false;

    if ('ontouchstart' in document.documentElement) {
        document.createEvent("TouchEvent");
        DRAG_E           = 'touchmove';
        DRAG_START_E     = 'touchstart';
        DRAG_END_E       = 'touchend';
        IS_TOUCH_ENABLED =  true;
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
        var selectMin, selectMax;

        _.bindAll(this, 'clickBar', 'enableDrag', 'disableDrag', 'drag');

        this.wrapper        = wrapper;
        this.options        = _.extend({}, Quinn.defaults, options);
        this.isDisabled     = false;
        this.isRange        = false;
        this.activeHandle   = null;
        this.handles        = [];

        this.previousValues = [];

        this.callbacks = {
            setup:  [],
            begin:  [],
            change: [],
            commit: [],
            abort:  []
        };

        if (_.isArray(this.options.value)) {
            this.isRange = true;
        }

        // For convenience.
        this.range      = this.options.range.slice();
        this.selectable = this.options.selectable || this.range;

        // The "selectable" values need to be fixed so that they match up with
        // the "step" option. For example, if given a step of 2, the values
        // need to be adjusted so that odd values are not possible...

        selectMin = this.__roundToStep(this.selectable[0]);
        selectMax = this.__roundToStep(this.selectable[1]);

        if (selectMin < this.selectable[0]) {
            selectMin += this.options.step;
        }

        if (selectMax > this.selectable[1]) {
            selectMax -= this.options.step;
        }

        this.selectable = [ selectMin, selectMax ];

        // Attaches the instance to the DOM node so that it can be accessed
        // by developers later.
        this.wrapper.data('quinn', this);

        // Create the slider DOM elements, and set the initial value.
        this.render();
        this.__setValue(this.options.value, false, false);

        if (this.options.disable === true) {
            this.disable();
        }

        this.bind('setup',  this.options.onSetup);
        this.bind('begin',  this.options.onBegin);
        this.bind('change', this.options.onChange);
        this.bind('commit', this.options.onCommit);
        this.bind('abort',  this.options.onAbort);

        // Fire the onSetup callback.
        this.trigger('setup');

        return this;
    }

    // The current Quinn version.
    Quinn.VERSION = '0.4.2';

    // ## Rendering

    /**
     * ### render
     *
     * Quinn is initialized with an empty wrapper element; render adds the
     * necessary DOM elements in order to display the slider UI.
     *
     * render() is called automatically when creating a new Quinn instance,
     * but should be called again if the slider is resized.
     */
    Quinn.prototype.render = function () {
        var barWidth = this.options.width || this.wrapper.width(),
            movableRange, handleWidth, handleDangle, i, length;

        function addRoundingElements(element) {
            element.append($('<div class="left" />'));
            element.append($('<div class="main" />'));
            element.append($('<div class="right" />'));
        }

        this.bar       = $('<div class="bar" />');
        this.activeBar = $('<div class="active-bar" />');

        if (this.isRange) {
            this.wrapper.addClass('range');

            for (i = 0, length = this.options.value.length; i < length; i++) {
                this.handles.push({
                    value:   this.options.value[i],
                    index:   i,
                    element: $('<span class="handle" />')
                });
            }
        } else {
            this.handles.push({
                value:   this.options.value,
                index:   0,
                element: $('<span class="handle" />')
            });
        }

        addRoundingElements(this.bar);
        addRoundingElements(this.activeBar);

        movableRange = $('<div class="movable-range" />');

        this.bar.append(this.activeBar);
        this.wrapper.html(this.bar);
        this.wrapper.addClass('quinn');

        this.wrapper.append(movableRange);

        // Add each of the handles to the bar, and bind the click events.
        for (i = 0, length = this.handles.length; i < length; i++) {
            this.handles[i].element.bind(DRAG_START_E, this.enableDrag);
            movableRange.append(this.handles[i].element);
        }

        // The slider depends on some absolute positioning, so  adjust the
        // elements widths and positions as necessary ...

        this.bar.css({ width: barWidth.toString() + 'px' });

        handleWidth = this.options.handleWidth ||
                      this.handles[0].element.width();

        // The "dangle" allows the handle to appear slightly to the left of
        // the slider bar.

        handleDangle = Math.round(handleWidth * 0.25);

        this.bar.css({
            marginLeft: handleDangle.toString() + 'px',
            width:      (barWidth - (handleDangle * 2)).toString() + 'px'
        });

        this.wrapper.find('.movable-range').css({
            width: (barWidth - handleWidth).toString() + 'px'
        });

        // Finally, these events are triggered when the user seeks to
        // update the slider.
        this.bar.bind('mousedown', this.clickBar);

        // IE7/8 isn't triggering when clicking on the bar, but only on
        // the movable-range. I'm not yet sure why.
        if ($.browser.msie && $.browser.version < 9.0) {
            movableRange.bind('mousedown', this.clickBar);
        }
    };

    /**
     * ### rePosition
     *
     * Moves the slider handle and the active-bar background elements so that
     * they accurately represent the value of the slider.
     */
    Quinn.prototype.rePosition = function (animate) {
        var opts   = this.options,
            delta  = this.range[1] - this.range[0];

        this.activeBar.stop(true);

        _.each(this.handles, _.bind(function(handle, i) {
            var percent, percentStr;

            percent    = (handle.value - this.range[0]) / delta * 100;
            percentStr = percent.toString() + '%';

            handle.element.stop(true);

            if (animate && opts.effects) {
                handle.element.animate({ left: percentStr }, {
                    duration: opts.effectSpeed,
                    step: _.bind(function (now) {
                        // "now" is the current "left" position of the handle.
                        // Convert that to the equivalent value. For example,
                        // if the slider is 0->200, and now is 20, the
                        // equivalent value is 40.
                        this.__positionActiveBar((now / 100) *
                            (this.range[1] - this.range[0]) + this.range[0],
                            handle);

                        return true;
                    }, this)
                });
            } else {
                // TODO being in the loop results in an unnecessary
                //      additional call to positionActiveBar
                handle.element.css('left', percentStr);
                this.__positionActiveBar(this.value);
            }
        }, this));
    };

    /**
     * ### __positionActiveBar
     *
     * Positions the blue active bar so that it originates at a position where
     * the value 0 is. Accepts a `value` argument so that it may be used
     * within a `step` callback in a jQuery `animate` call.
     */
    Quinn.prototype.__positionActiveBar = function (value, handle) {
        var leftPosition = null, rightPosition = null;

        if (this.isRange) {
            if (handle) {
                if (handle.index === 0) {
                    leftPosition  = this.__positionForValue(value);
                } else {
                    rightPosition = this.__positionForValue(value);
                }
            } else {
                leftPosition  = this.__positionForValue(value[0]);
                rightPosition = this.__positionForValue(value[1]);
            }
        } else if (value < 0) {
            // position with the left edge underneath the handle, and the
            // right edge at 0
            leftPosition  = this.__positionForValue(value);
            rightPosition = this.__positionForValue(0);
        } else {
            // position with the right edge underneath the handle, and the
            // left edge at 0
            leftPosition  = this.__positionForValue(0);
            rightPosition = this.__positionForValue(value);
        }

        rightPosition = this.bar.width() - rightPosition;

        if (leftPosition !== null) {
            this.activeBar.css('left', leftPosition.toString() + 'px');
        }

        if (rightPosition !== null) {
            this.activeBar.css('right', rightPosition.toString() + 'px');
        }
    };

    // ## Slider Manipulation

    /**
     * ### setValue
     *
     * Updates the value of the slider to `newValue`. If the `animate`
     * argument is truthy, the change in value will be animated when updating
     * the slider position. The onChange callback may be skipped if
     * `doCallback` is falsey.
     *
     * This is the public version of __setValue which is a public API method;
     * use this in your application code when you need to change the slider
     * value.
     */
    Quinn.prototype.setValue = function (newValue, animate, doCallback) {
        if (this.__willChange()) {
            if (this.__setValue(newValue, animate, doCallback)) {
                this.__hasChanged();
            } else {
                this.__abortChange();
            }
        }

        return this.value;
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
    Quinn.prototype.stepUp = function (count) {
        if (this.isRange) {
            // Cannot step a range-based slider.
            return this.value;
        }

        return this.setValue(this.value + this.options.step * (count || 1));
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
    Quinn.prototype.stepDown = function (count) {
        return this.stepUp(-(count || 1));
    };

    /**
     * ### disable
     *
     * Disables the slider so that a user may not change it's value.
     */
    Quinn.prototype.disable = function () {
        this.isDisabled = true;
        this.wrapper.addClass('disabled');

        if (this.options.disabledOpacity !== 1.0) {
            this.wrapper.css('opacity', this.options.disabledOpacity);
        }
    };

    /**
     * ### enable
     *
     * Enables the slider so that a user may change it's value.
     */
    Quinn.prototype.enable = function () {
        this.isDisabled = false;
        this.wrapper.removeClass('disabled');

        if (this.options.disabledOpacity !== 1.0) {
            this.wrapper.css('opacity', 1.0);
        }
    };

    // ## Event Handlers

    /**
     * ### bind
     *
     * Binds a `callback` to be run whenever the given `event` occurs. Returns
     * the Quinn instance permitting chaining.
     */
    Quinn.prototype.bind = function (event, callback) {
        if (_.isString(event) && _.isFunction(callback)) {
            if (event.slice(0, 2) === 'on') {
                // In case the user gave the longer form 'onChange', etc.
                event = event.slice(2, event.length).toLowerCase();
            }

            this.callbacks[event].push(callback);
        }

        return this;
    };

    /**
     * ### trigger
     *
     * Runs the callbacks of the given type.
     *
     * If any of the callbacks return false, other callbacks will not be run,
     * and trigger will return false; otherwise true is returned.
     */
    Quinn.prototype.trigger = function (event, value) {
        var callbacks = this.callbacks[event],
            callback, i = 0;

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

        if (this.__willChange()) {
            this.__activateHandleWithEvent(event);
            this.__setValue(this.__valueFromMouse(event.pageX), true);

            // Allow user to further refine the slider value by dragging
            // without releasing the mouse button. `disableDrag` will take
            // care of committing the final updated value. This doesn't
            // work nicely on touch devices, so we don't do this there.
            if (IS_TOUCH_ENABLED) {
                this.__hasChanged();
            } else {
                this.enableDrag(event, true);
            }
        }

        return event.preventDefault();
    };

    /**
     * ### enableDrag
     *
     * Begins a drag event which permits a user to move the slider handle in
     * order to adjust the slider value.
     *
     * When `skipPreamble` is true, enableDrag will not run the
     * `__willChange()` on the assumption that it has already been run
     * (see `clickBar`).
     */
    Quinn.prototype.enableDrag = function (event, skipPreamble) {
        var handle;

        // Only enable dragging when the left mouse button is used.
        if (! IS_TOUCH_ENABLED && event.which !== 1) {
            return true;
        }

        if (! skipPreamble && ! this.__willChange()) {
            return false;
        }

        this.__activateHandleWithEvent(event);

        // These events are bound for the duration of the drag operation and
        // keep track of the value changes made, with the events being removed
        // when the mouse button is released.
        $(document).
            bind(DRAG_END_E + '.quinn', this.disableDrag).
            bind(DRAG_E     + '.quinn', this.drag).

            // The mouse may leave the window while dragging, and the mouse
            // button released. Watch for the mouse re-entering, and see what
            // the button is doing.
            bind('mouseenter.quinn', this.disableDrag);

        return event.preventDefault();
    };

    /**
     * ### disableDrag
     *
     * Run when the user lifts the mouse button after completing a drag.
     */
    Quinn.prototype.disableDrag = function (event) {
        // Remove the events which were bound in `enableDrag`.
        $(document).
            unbind(DRAG_END_E + '.quinn').
            unbind(DRAG_E + '.quinn').
            unbind('mouseenter.quinn');

        this.activeHandle.element.removeClass('active');
        this.__hasChanged();

        return event.preventDefault();
    };

    /**
     * ### drag
     *
     * Bound to the mousemove event, alters the slider value while the user
     * contiues to hold the left mouse button.
     */
    Quinn.prototype.drag = function (event) {
        var pageX = event.pageX, newValue;

        if (event.type === 'touchmove') {
            pageX = event.originalEvent.targetTouches[0].pageX;
        }

        this.__setValue(this.__valueFromMouse(pageX));

        return event.preventDefault();
    };

    // ## Psuedo-Private Methods

    /**
     * Given a click or drag event, determines the closest handle and
     * activates it. Does nothing if a handle is already active.
     */
    Quinn.prototype.__activateHandleWithEvent = function (event) {
        var pageX = event.pageX, value;

        if (this.activeHandle) {
            return false;
        }

        if (event.type === 'touchmove') {
            pageX = event.originalEvent.targetTouches[0].pageX;
        }

        value = this.__valueFromMouse(pageX);

        this.activeHandle = _.min(this.handles, function (handle) {
            return Math.abs(handle.value - value);
        });

        this.activeHandle.element.addClass('active');
    };

    /**
     * ### __valueFromMouse
     *
     * Determines the value of the slider at the position indicated by the
     * mouse cursor.
     */
    Quinn.prototype.__valueFromMouse = function (mousePosition) {
        var percent = this.__positionFromMouse(mousePosition),
            delta   = this.range[1] - this.range[0];

        return this.range[0] + delta * (percent / 100);
    };

    /**
     * ### __positionFromMouse
     *
     * Determines how far along the bar the mouse cursor is as a percentage of
     * the bar's width.
     */
    Quinn.prototype.__positionFromMouse = function (mousePosition) {
        var barWidth = this.bar.width(),
            maxLeft  = this.bar.offset().left,
            maxRight = maxLeft + barWidth,
            barPosition;

        if (mousePosition < maxLeft) {
            // Mouse is to the left of the bar.
            barPosition = 0;
        } else if (mousePosition > maxRight) {
            // Mouse is to the right of the bar.
            barPosition = barWidth;
        } else {
            barPosition = mousePosition - maxLeft;
        }

        return barPosition / barWidth * 100;
    };

    /**
     * ### __positionForValue
     *
     * Given a slider value, returns the position in pixels where the value is
     * on the slider bar. For example, in a 200px wide bar whose values are
     * 1->100, the value 20 is found 40px from the left of the bar.
     */
    Quinn.prototype.__positionForValue = function (value) {
        var barWidth = this.bar.width(),
            delta    = this.range[1] - this.range[0],
            position = (((value - this.range[0]) / delta)) * barWidth;

        if (position < 0) {
            return 0;
        } else if (position > barWidth) {
            return barWidth;
        } else {
            return Math.round(position);
        }
    };

    /**
     * ### __roundToStep
     *
     * Given a number, rounds it to the nearest step.
     *
     * For example, if options.step is 5, given 4 will round to 5. Given
     * 2 will round to 0, etc. Does not take account of the minimum and
     * maximum range options.
     */
    Quinn.prototype.__roundToStep = function (number) {
        var multiplier = 1 / this.options.step,
            rounded    = Math.round(number * multiplier) / multiplier;

        if (_.isArray(this.options.only)) {
            rounded = _.min(this.options.only, function (value) {
                return Math.abs(value - number);
            });
        }

        if (rounded > this.selectable[1] ) {
            return rounded - this.options.step;
        } else if (rounded < this.selectable[0]) {
            return rounded + this.options.step;
        } else {
            return rounded;
        }
    };

    /**
     * #### __sanitizeValue
     *
     * Given a numberic value, snaps it to the nearest step, and ensures that
     * it is within the selectable minima and maxima.
     */
    Quinn.prototype.__sanitizeValue = function (value) {
        value = this.__roundToStep(value);

        if (value < this.selectable[0]) {
            return this.selectable[0];
        } else if (value > this.selectable[1]) {
            return this.selectable[1];
        }

        return value;
    };

    /**
     * ### __willChange
     *
     * Tells the Quinn instance that the user is about to make a change to the
     * slider value. The calling function should check the return value of
     * __willChange -- if false, no changes are permitted to the slider.
     */
    Quinn.prototype.__willChange = function () {
        if (this.isDisabled === true || ! this.trigger('begin')) {
            return false;
        }

        this.previousValues.unshift(this.value);
        return true;
    };

    /**
     * ### __hasChanged
     *
     * Tells the Quinn instance that the user has finished making their
     * changes to the slider.
     */
    Quinn.prototype.__hasChanged = function () {
        this.activeHandle = null;

        // Run the onCommit callback; if the callback returns false then we
        // revert the slider change, and restore everything to how it was
        // before. Note that reverting the change will also fire an onChange
        // event when the value is reverted.
        if (! this.trigger('commit')) {
            this.__setValue(_.head(this.previousValues), true);
            this.__abortChange();

            return false;
        }

        if (_.head(this.previousValues) === this.value) {
            // The user reset the slider back to where it was.
            this.__abortChange();
        }
    };

    /**
     * ### __abortChange
     *
     * Aborts a slider change, and restores it to it's previous state.
     */
    Quinn.prototype.__abortChange = function () {
        this.activeHandle   = null;
        this.previousValues = _.tail(this.previousValues);

        return this.trigger('abort');
    };

    /**
     * ### __setValue
     *
     * Internal method which changes the slider value. See setValue.
     */
    Quinn.prototype.__setValue = function (newValue, animate, doCallback) {
        var originalValue = this.value, numberValue, i, length, handle;

        if (this.isRange) {

            // RANGE-BASED SLIDERS

            if (_.isArray(newValue)) {
                if (this.value != null) {
                    originalValue = _.clone(originalValue);

                    if (newValue.length != originalValue.length) {
                        return false;
                    }
                } else {
                    // Value is uninitialized when called for the first time.
                    this.value = [];
                }

                // Don't mutate the original array.
                newValue = _.clone(newValue);

                for (i = 0, length = newValue.length; i < length; i++) {
                    newValue[i] = this.__sanitizeValue(newValue[i]);
                }
            } else if (_.isNumber(newValue)) {
                if (! this.activeHandle) {
                    // Number values are only accepted during drag events,
                    // when the activeHandle has been set.
                    return false;
                }

                newValue = this.__sanitizeValue(newValue);

                if (this.activeHandle.index === 1) {
                    if (newValue <= this.handles[0].value) {
                        newValue = this.handles[0].value +
                            this.options.step;
                    }
                } else {
                    if (newValue >= this.handles[1].value) {
                        newValue = this.handles[1].value -
                            this.options.step;
                    }
                }

                numberValue = newValue;

                newValue = _.clone(this.value);
                newValue[this.activeHandle.index] = numberValue;
            } else {
                // The default slider value when initialized is "null", so
                // default to setting the range to the slider minimum and
                // maximum permitted value.
                newValue = _.clone(this.selectable);
            }

            if (_.isEqual(originalValue, newValue)) {
                // No values were changed.
                return false;
            }

            this.value = newValue;

        } else {

            // SINGLE VALUE SLIDERS

            if (_.isNumber(newValue)) {
                newValue = [ this.__sanitizeValue(newValue) ];
            } else {
                // The default slider value when initialized is "null", so
                // default to setting the range to the slider minimum
                // permitted value.
                newValue = [ this.selectable[0] ];
            }

            if (originalValue === newValue[0]) {
                // No values were changed.
                return false;
            }

            this.value = newValue[0];
        }

        // Run the onChange callback; if the callback returns false then stop
        // immediately and do not change the value.
        if (! this.trigger('change', this.value)) {
            this.value = originalValue;
            return false;
        }

        for (i = 0, length = this.handles.length; i < length; i++) {
            this.handles[i].value = newValue[i];
        }

        this.rePosition(animate);

        return true;
    };

    /**
     * ### Options
     *
     * Default option values which are used when the user does not explicitly
     * provide them.
     */
    Quinn.defaults = {
        // An array with the lowest and highest values represented by the
        // slider.
        range: [0, 100],

        // The range of values which can be selected by the user. Normally
        // this would be the same as "range", however this option allows you
        // to make only a portion of the slider selectable.
        selectable: null,

        // The "steps" by which the selectable value increases. For example,
        // when set to 2, the default slider will increase in steps from 0, 2,
        // 4, 8, etc.
        step: 1,

        // The initial value of the slider. null = the lowest value in the
        // range option.
        value: null,

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
        // callbacks may be added with Quinn#bind('change').
        //
        // Arguments:
        //   number: the altered slider value
        //   Quinn:  the Quinn instance
        //
        onChange: null,

        // Run after the user has finished making a change.
        //
        // Arguments:
        //   number: the new slider value
        //   Quinn:  the Quinn instance
        //
        onCommit: null,

        // Run once after the slider has been constructed.
        //
        // Arguments:
        //   number: the current slider value
        //   Quinn:  the Quinn instance
        //
        onSetup: null,

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
