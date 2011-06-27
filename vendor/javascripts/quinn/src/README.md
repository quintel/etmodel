Quinn
=====

[Quinn][github] is a jQuery-based library which creates sliders (aka.
ranges, aka. track  bars) for HTML applications. The project is hosted
on [GitHub][github]; you can report bugs and discuss features on the
[issue tracker][issues], or direct your tweets at [@antw][twitter]. An
[annotated version][annotated] of the source is available.

    $('.slider').quinn();

The library requires [jQuery][jq] and [Underscore.js][us].

Quinn has been tested and works in the following environments:

 - Chrome 11 and 12
 - Firefox 3.5 and 4.0
 - Safari 4
 - Opera 11
 - Internet Explorer 7 and 8
 {:.yes}

There are no plans to support Internet Explorer 6. The unit tests can
be run [in your browser][tests].

Quinn was developed by [~antw][antw] as part of Quintel
Intelligence's [Energy Transition Model][etm] application, and has been
open-sourced with their kind permission. Quinn is released under the
[New BSD License][license].

Downloads
---------

[Everything (0.2.1)][tarball]
:   Tarball containing JS, CSS, and images

[Development Version (0.2.1)][development-js]
:   13.3kb, JS only, Uncompressed with comments

[Production Version (0.2.1)][production-js]
:   1.54kb, JS only, Minified and Gzipped

Table of Contents
-----------------

#### Options

[Minima and Maxima][range], [Initial Values][value],
[Steps][step], [Selectable Ranges][selectable], [Effects][effects],
[Specific Values][only], [Disabling the Slider][disable]

#### Callbacks

[onSetup][onsetup], [onBegin][onbegin], [onChange][onchange],
[onCommit][oncommit], [onAbort][onabort]

#### [Theming][theming]

Options
-------

In order to customise the appearance and behaviour of the Quinn slider
instance, you may pass extra options when initializing:

    $(selector).quinn(optionsHash);
{:.no-example}

### Minima and Maxima `range: [min, max]` {#range}

By default, a Quinn slider allows selection of whole numbers between 0
and 100. By supplying a **range** option, you can change these values:
**range** should be an array of two values, where the first value is the
minimum value represented on the slider, and the second is the maximum.

    // Our volume knobs go up to eleven.
    $('.slider').quinn({ range: [ 0, 11 ] });

Negative values are perfectly acceptable, but the "active bar" (the blue
background) doesn't yet handle this correctly -- it ought to originate
at zero rather than always on the left.

    $('.slider').quinn({ range: [ -100, 0 ] });

### Initial Values `value: number` {#value}

When a slider is created without a default value, it will initialize
with the slider in the minimum value position. Supplying a **value**
option results in the slider being created with a different starting
value.

    $('.slider').quinn({ value: 25 });

### Steps `step: number` {#step}

The **step** option restricts the values which may be selected using the
slider to numbers which are divisible by the step without a remainder.
For example, a step of 10 only 0, 10, 20, 30, ..., n, to be chosen.

    $('.slider').quinn({ step: 10 });

If you supply an initial value which can't be used as it doesn't "fit"
with the step, the value will be rounded to the nearest acceptable point
on the slider. For example, an step of 10, and an initial value of 17
will result in the slider being initialized with a value of 20 instead.

Combining the **step** option with **[range][range]** permits the
creation of sliders with arbitrary values:

    $('.slider').quinn({ range: [0, 1.21], step: 0.01 });

### Selectable Ranges `selectable: [min, max]` {#selectable}

Sometimes you want to show a slider where only a certain partition of
the values may be chosen by the user. This is achieved using the
**selectable** option.

The example below is created with the default range `[0, 100]`, but
restricts the values the user may select:

    $('.slider').quinn({ selectable: [35, 80] });

The "selectable" values can be changed later with `setSelectable(min,
max)`.

When using **selectable**, your **step** option will still be respected
and **selectable** values which don't fit with the step will be rounded
to the nearest inclusive step. Note that in the example below the lowest
selectable value (5) is not available since `step: 20` is used. The
lower value is instead rounded to 20 (not 0 since this is outside the
selectable range supplied and might break your data validation later).

    $('.slider').quinn({ selectable: [5, 80], step: 20 });

### Effects `effects: bool` `effectSpeed: number` {#effects}

Some Quinn actions make use of jQuery effects. For example, clicking on
the slider bar immediately changes the value and animates movement of
the handle to the new position. Animation length may be altered with the
**effectSpeed** option which may be any valid jQuery animation length
(fast, slow, or a number), or disabled completely by setting `effects:
false`.

If the [Easing][easing] library is available, your default animation
easing function will be used.

    $('.slider').quinn({ effects: false });

### Specific Values `only: [value, value, ...]` {#only}

To create a slider where the user may select only from specific values,
use the **only** option with an array of values which may be chosen.

    $('.slider').quinn({ only: [10, 15, 50, 80], value: 50 });

### Disabling the Slider `disable: bool` {#disable}

When you do not wish the user to be able to interact with the slider,
pass `false` with the **disable** option:

    $('.slider').quinn({ value: 50, disable: true });

Callbacks
---------

The behavior of the slider may be further customised through the use of
callback functions which are supplied as part of the options object when
creating the slider.

When the user alters the slider position, the order of events firing is:

 1. **[onBegin][onbegin]**: Each time the user starts changing the slider value.
 2. **[onChange][onchange]**: Repeatedly as the user drags the handle to new
    positions.
 3. **[onCommit][oncommit]**: When the user releases the mouse button.
 4. **[onAbort][onabort]**: When the user releases the mouse button, and the
    onCommit callback returns false.

In addition to supplying callbacks when initializing a slider, you may
bind further callbacks to the Quinn instance:

    var slider = new $.Quinn(element, options);

    slider.bind('change', function (value) {
        console.log(value);
    });

    slider.bind('abort', function (value) {
        console.log('Value reset to ' + value);
    });
{:class="no-example"}

### onSetup `onSetup: function (currentValue, quinn)` {#onsetup}

**onSetup** is run only once, immediately after the Quinn constructor
has completed. Two arguments are supplied: the current value of the
slider and the Quinn instance. Note that the slider value given during
initialization may differ from the one given to the callback since the
constructor adjusts the slider value to fit with the **range**,
**selectable**, and **step** options. The value supplied to the
callback is correct.

### onBegin `onBegin: function (currentValue, quinn)` {#onbegin}

**onBegin** is fired as the user starts to adjust the slider value. This
happens when they click on the slider bar, or on the handle _prior_ to
the slider being dragged to a new position.

### onChange `onChange: function (newValue, quinn)` {#onchange}

The **onChange** callback is run each time the slider value changes. The
function is supplied with two arguments: the new slider value, and the
Quinn instance. The previous value of the slider can be retrieved with
`quinn.value` since the value attribute is only updated after the
callback has completed.

    function changeValueColour (value) {
        var h = (128 - value * 1.28).toFixed(),
            l = (35 + value * 0.1).toFixed();

        $('.value').css('color', 'hsl('+h+', 50%, '+l+'%)');
    }

    $('.slider').quinn({
        onChange: function (newValue, slider) {
            changeValueColour(newValue);
        },

        onSetup: function (value, slider) {
            // Set the initial colour.
            changeValueColour(value);
        }
    });

Be aware that the **onChange** callback is run every time the slider
value changes, which can be extremely frequent when dragging the slider
handle. This is perfect for "hooking" in to the slider to display the
value elsewhere in your UI (such as the examples on this page), to
update a graph in real-time, etc, but is not suitable for persisting the
slider value to a server unless you like flooding your application with
tens of HTTP requests per second. Use **onCommit** which is fired only
after the user has finished dragging the handle.

Explicitly returning false in the callback will prevent the change.

    $('.slider').quinn({
        onChange: function (newValue, slider) {
            // Prevent selection of 41 to 59.
            if (newValue > 40 && newValue < 60) {
                return false;
            }
        }
    });

### onCommit `onCommit: function (newValue, quinn)` {#oncommit}

**onCommit** is similar to the to the **onChange** event in that it is
fired when the slider value is changed by a user. However, unlike
**onChange** it is fired only after the user has _finished_ changing the
value. This is defined as clicking the slider bar to change the value,
or lifting the left mouse button after dragging the slider handle.

    $('.slider').quinn({
        value: 25,

        onCommit: function (newValue, slider) {
            // Disallow selecting a value over 50, but only
            // after the user has finished moving the slider.
            if (newValue > 50) {
                return false;
            }
        }
    });

### onAbort `onAbort: function (restoredValue, quinn)` {#onabort}

The **onAbort** event is fired once the user has finished adjusting the
value (like **onCommit**) but the change failed either because the
**onCommit** callback returned false, or the user set the slider back
to it's starting value.

Theming
-------

Altering Quinn's appearance is relatively simple. The default style uses
a [single-image sprite][default-sprite]. If you don't need to resize any
of the slider elements, replacing this image with
[an alternative][rainbow-sprite] is all it takes. In some cases, you may
need to alter the CSS. For example:

    .rainbow .bar .left, .rainbow .bar .main, .rainbow .bar .right,
    .rainbow .active-bar .left, .rainbow .active-bar .main,
    .rainbow .active-bar .right, .rainbow .handle {
      background-image: url(vendor/rainbow.png);
    }

    .rainbow .bar, .rainbow .bar .left, .rainbow .bar .main,
    .rainbow .bar .right, .rainbow .active-bar .left,
    .rainbow .active-bar .main, .rainbow .active-bar .right {
      height: 25px;
    }

    .rainbow .handle {
      height: 23px;
      width: 23px;
    }
{:class="no-example css"}

    function changeValueColour (value) {
        var h = (128 - value * 1.28).toFixed(),
            l = (35 + value * 0.1).toFixed();

        $('.value').css('color', 'hsl('+h+', 50%, '+l+'%)');
    }

    $('.slider').quinn({
        value: 25,

        onChange: function (newValue, slider) {
            changeValueColour(newValue);
        },

        onSetup: function (value, slider) {
            // Set the initial colour.
            changeValueColour(value);
        }
    });
{:class="rainbow hide-code"}

History
-------

#### Git Head (will be 0.3.0)

Events may be bound to the Quinn instance just like DOM events in jQuery
using `bind`. The onComplete callback has been renamed onCommit.

#### 0.2.1 _June 14th, 2011_

Quinn has now been tested and fixed for IE7, urgh. Opera has been tested
and, unsurprisingly, works perfectly.

#### 0.2.0 _June 13th, 2011_

`stepUp` and `stepDown` have been added which are similar to the methods
of the same name on HTML 5 range and number inputs. Quinn instances may
now be created using `new $.Quinn(...)` if you need to hang on to the
slider instance after creation. Default theme changed to use a modified
version of Aristo. Fixed an issue when using `selectable` with `step`
when the selectable options didn't fit the step.

#### 0.1.6 _June 10th, 2011_

The `only` option has been added which restricts the choosable values
to those which are in the `only` array. Respects the `selectable` and
`range` settings. Clicking in the space above the visible slider bar now
correctly triggers events.

#### 0.1.4 _June 9th, 2011_

Adds support for touch devices (iOS, Android, etc). Various small fixes
to make the library "more jQuery-like", including the ability to chain
other functions off `$.fn.quinn()`. "Click-dragging" no longer fires two
`onComplete` events; only one when the user releases the mouse button.

#### 0.1.2 _June 9th, 2011_

When clicking on the slider bar, the mouse button may be held down to refine
the value by dragging the handle. The click and drag actions will fire
separate `onComplete` events.

#### 0.1.0 _June 8th, 2011_

Initial release on GitHub. Supports most planned features, but tests in
Opera and Internet Explorer are not yet complete.

[github]:         http://github.com/antw/quinn
[issues]:         http://github.com/antw/quinn/issues
[twitter]:        http://twitter.com/antw
[antw]:           http://github.com/antw
[annotated]:      http://antw.github.com/quinn/docs/jquery.quinn.html
[tests]:          http://antw.github.com/quinn/test
[etm]:            http://www.energytransitionmodel.com
[license]:        http://github.com/antw/quinn/blob/master/LICENSE
[jq]:             http://jquery.com
[us]:             http://documentcloud.github.com/underscore
[easing]:         http://gsgd.co.uk/sandbox/jquery/easing

[tarball]:        https://github.com/antw/quinn/tarball/v0.2.1
[development-js]: http://antw.github.com/quinn/jquery.quinn.js
[production-js]:  http://antw.github.com/quinn/jquery.quinn.min.js

[default-sprite]: http://antw.github.com/quinn/images/default.png
[rainbow-sprite]: http://antw.github.com/quinn/vendor/rainbow.png

[range]:          #range
[value]:          #value
[step]:           #step
[selectable]:     #selectable
[effects]:        #effects
[only]:           #only
[disable]:        #disable
[onsetup]:        #onsetup
[onbegin]:        #onbegin
[onchange]:       #onchange
[oncommit]:       #oncommit
[onabort]:        #onbort
[theming]:        #theming
