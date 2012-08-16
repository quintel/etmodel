Quinn
=====

Are you viewing this README on Github? Head to the [Quinn homepage][home]
where all of the examples below are fully interactive.
{:.github}

[Quinn][github] is a jQuery-based library which creates sliders (aka. ranges,
aka. track bars) for HTML applications. The project is hosted on
[GitHub][github]; you can report bugs and discuss features on the
[issue tracker][issues], or direct your tweets at [@antw][twitter]. An
[annotated version][annotated] of the source is available.

    $('.slider').quinn();

The library requires [jQuery][jq] and [Underscore.js 0.3.1+][us].

Quinn has been tested and works in the following environments:

 - Chrome 11 and newer
 - Firefox 3.5 and newer
 - Safari 4
 - Opera 11
 - Internet Explorer 7 and 8
 {:.yes}

There are no plans to support Internet Explorer 6. The unit tests can be run
[in your browser][tests].

Quinn was developed by [~antw][antw] as part of Quintel Intelligence's
[Energy Transition Model][etm] application. It is released under the
[New BSD License][license].

Downloads
---------

[Everything (1.0.5)][tarball]
:   Tarball containing JS, CSS, and images

[Development Version (1.0.5)][development-js]
:   33.6kb, JS only, Uncompressed with comments

[Production Version (1.0.5)][production-js]
:   2.8kb, JS only, Minified and Gzipped

Table of Contents
-----------------

#### Options

[Minima and Maxima][extrema], [Initial Values][value], [Steps][step],
[Drawing Options][drawTo], [Multiple Values][values], [Effects][effects],
[Specific Values][only], [Disabling the Slider][disable]

#### [Callbacks][callbacks]

[setup][onsetup], [begin][onbegin], [drag][ondrag], [change][onchange],
[abort][onabort]

#### [Theming][theming]

#### [History][history]

Options
-------

In order to customise the appearance and behaviour of the Quinn slider
instance, you may pass extra options when initializing:

    $(selector).quinn(optionsHash);
{:.no-example}

### Minima and Maxima `min: value, max: value` {#extrema}

By default, a Quinn slider allows selection of whole numbers between 0 and
100. By supplying **min** and **max** options, you can change these values.

    /* Our volume knobs go up to eleven. */
    $('.slider').quinn({ min: 0, max: 11 });

Negative values are perfectly acceptable, and the "active bar" (the blue
background) will always be anchored at zero.

    $('.slider').quinn({ min: -100, max: 100 });

### Initial Values `value: number` {#value}

When a slider is created without a default value, it will initialize with the
slider in the minimum value position. Supplying a **value** option results in
the slider being created with a different starting value.

    $('.slider').quinn({ value: 25 });

### Steps `step: number` {#step}

The **step** option restricts the values which may be selected using the
slider to numbers which are divisible by the step without a remainder. For
example, a step of 10 only 0, 10, 20, 30, ..., n, to be chosen.

    $('.slider').quinn({ step: 10 });

If you supply an initial value which can't be used as it doesn't "fit" with
the step, the value will be rounded to the nearest acceptable point on the
slider. For example, an step of 10, and an initial value of 17 will result in
the slider being initialized with a value of 20 instead. This behaviour can
be disabled *for the initial value* by also supplying `strict: false`.

Combining the **step** option with [**min** and **max**][extrema] options
permits the creation of sliders with arbitrary values:

    $('.slider').quinn({ min: 0, max: 1.21, step: 0.01 });

When using **step**, your provided minimum and maximum values may be altered
to ensure that they "fit" the step correctly. Note that in the example below
the minimum value 5 is not available since `step: 20` is used. The lower
value is instead rounded to 20 (not 0 since this is lower than the minimum
chosen when creating the slider). Similarly, 95 is rounded down to the nearest
inclusive step, 80.

    $('.slider').quinn({ min: 5, max: 95, step: 20 });

### Drawing Options `drawTo: { left: from, right: to }` {#drawTo}

Sometimes you might want to draw a slider which is wider than the **min** and
**max** options you gave it. This is achieved by passing a two-element array
as **drawTo**.

The example below draws the slider from a value of 0 up to 100, but only
permits selecting a value between 30 and 70.

    $('.slider').quinn({
        min: 30, max: 70, drawTo: { left: 0, right: 100 }
    });

### Multiple Values `value: [value1, value2, ..., valueN]` {#values}

Instead of a Quinn slider having a single value, it may instead be used to
represent a range of values, with a lower and upper value. Simply supply an
array with two numeric values.

    $('.slider').quinn({ value: [25, 75] });

Quinn isn't limited to two values; add as many as you want, but with the
default renderer using more than two values will disable the blue "delta" bar.

    $('.slider').quinn({ value: [15, 30, 70, 85] });

### Effects `effects: bool` `effectSpeed: number` {#effects}

Some Quinn actions make use of jQuery effects. For example, clicking on the
slider bar immediately changes the value and animates movement of the handle
to the new position. Animation length may be altered with the **effectSpeed**
option which may be any valid jQuery animation length (fast, slow, or a
number), or disabled completely by setting `effects: false`.

If the [Easing][easing] library is available, your default animation easing
function will be used.

    $('.slider').quinn({ effects: false });

### Specific Values `only: [value, value, ...]` {#only}

To create a slider where the user may select only from specific values, use
the **only** option with an array of values which may be chosen.

    $('.slider').quinn({ only: [10, 15, 50, 80], value: 50 });

### Disabling the Slider `disable: bool` {#disable}

When you do not wish the user to be able to interact with the slider, pass
`false` with the **disable** option:

    $('.slider').quinn({ value: 50, disable: true });

Callbacks
---------

The behavior of the slider may be further customised through the use of
callback functions which are supplied as part of the options object when
creating the slider.

When the user alters the slider position, the order of events firing is:

 1. **[begin][onbegin]**: Each time the user starts changing the slider value.
 2. **[drag][ondrag]**: Repeatedly as the user drags the handle to new
    positions. If the callbacks all return true, and the value was changed, a
    `redraw` event is then fired. `redraw` is considered internal and should
    be used only if implementing your own renderer.
 3. **[change][onchange]**: When the user releases the mouse button.
 4. **[abort][onabort]**: When the user releases the mouse button, and the
    change callback returns false.

In addition to supplying callbacks when initializing a slider, you may bind
further callbacks to the Quinn instance:

    var slider = new $.Quinn(element, options);

    slider.on('drag', function (value) {
        console.log(value);
    });

    slider.on('abort', function (value) {
        console.log('Value reset to ' + value);
    });
{:class="no-example"}

### setup `setup: function (currentValue, quinn)` {#onsetup}

**setup** is run only once, immediately after the Quinn constructor has
completed. Two arguments are supplied: the current value of the slider and the
Quinn instance. Note that the slider value given during initialization may
differ from the one given to the callback since the constructor adjusts the
slider value to fit with the **min**, **max**, and **step** options. The value
supplied to the callback is correct.

### begin `begin: function (currentValue, quinn)` {#onbegin}

**begin** is fired as the user starts to adjust the slider value. This happens
when they click on the slider bar, or on the handle _prior_ to the slider
being dragged to a new position.

### drag `drag: function (newValue, quinn)` {#ondrag}

The **drag** callback is run each time the slider value changes. The function
is supplied with two arguments: the new slider value, and the Quinn instance.

    function changeValueColour (value) {
        var h = (128 - value * 1.28).toFixed(),
            l = (35 + value * 0.1).toFixed();

        $('.value').css('color', 'hsl('+h+', 50%, '+l+'%)');
    }

    $('.slider').quinn({
        drag: function (newValue, slider) {
            changeValueColour(newValue);
        },

        setup: function (value, slider) {
            /* Set the initial colour. */
            changeValueColour(value);
        }
    });

Be aware that the **drag** callback is run every time the slider value
changes, which can be extremely frequent when dragging the slider handle. This
is perfect for "hooking" in to the slider to display the value elsewhere in
your UI (such as the examples on this page), to update a graph in real-time,
etc, but is not suitable for persisting the slider value to a server unless
you like flooding your application with tens of HTTP requests per second. Use
**change** which is fired only after the user has finished dragging the
handle.

Explicitly returning false in the callback will prevent the change.

    $('.slider').quinn({
        drag: function (newValue, slider) {
            /* Prevent selection of 41 to 59. */
            if (newValue > 40 && newValue < 60) {
                return false;
            }
        }
    });

### change `change: function (newValue, quinn)` {#onchange}

**change** is similar to the to the **drag** event in that it is fired when
the slider value is changed by a user. However, unlike **drag** it is fired
only after the user has _finished_ changing the value. This is defined as
clicking the slider bar to change the value, or lifting the left mouse button
after dragging the slider handle.

    $('.slider').quinn({
        value: 25,

        change: function (newValue, slider) {
            /* Disallow selecting a value over 50, but only
               after the user has finished moving the slider. */
            if (newValue > 50) {
                return false;
            }
        }
    });

### abort `abort: function (restoredValue, quinn)` {#onabort}

The **abort** event is fired once the user has finished adjusting the value
(like **change**) but the change failed either because the **change** callback
returned false, or the user set the slider back to the value it was at before
they began dragging.

Theming
-------

Altering Quinn's appearance is relatively simple. The default style uses a
[single-image sprite][default-sprite]. If you don't need to resize any of the
slider elements, replacing this image with [an alternative][rainbow-sprite] is
all it takes. In some cases, you may need to alter the CSS. For example:

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
      height: 24px;
      width: 24px;
    }
{:class="no-example css"}

    function changeValueColour (value) {
        var h = (128 - value * 1.28).toFixed(),
            l = (35 + value * 0.1).toFixed();

        $('.value').css('color', 'hsl('+h+', 50%, '+l+'%)');
    }

    $('.slider').quinn({
        value: 25,

        drag: function (newValue, slider) {
            changeValueColour(newValue);
        },

        setup: function (value, slider) {
            /* Set the initial colour. */
            changeValueColour(value);
        }
    });
{:class="rainbow hide-code"}

History
-------

#### 1.0.5 _August 16th, 2012_

* Added support for changing the value with the keyboard arrow keys, page
  up and down. Alt+Left and Alt+Right will instantly set the minimum and
  maximum values respectively.

  A new option, `keyFloodWait`, will impose a delay after the user lifts a
  key, to wait and see if they repeatedly press the key to further alter
  the value. This is disabled by default, but may be useful if you trigger
  an expensive action (e.g. XmlHttpRequest) whenever the slider value
  changes.

#### 1.0.2 _July 11th, 2012_

* Added a HiDPI "Retina" sprite. If you wish to use it, be sure to update
  not only your copy of the Quinn JS, but also the CSS file and new image
  from the "images" directory.

#### 1.0.1 _May 10th, 2012_

* Added a `strict` option which prevents the initial value being snapped
  to the `step` value.

#### 1.0.0 _April 14th, 2012_

* **This release contains changes which are not backwards-compatible with
  previous versions.** You should only need to make small changes, but this
  release is not "add to the repo and go"...

* Underscore dependency is now v1.3.1 or newer.

* The `range` and `selectable` options has been removed and replaced with
  `min` and `max`. If you wish to draw a slider wider than the minimum and
  maximum values (previously possible with a combination of `range` and
  `selectable`) you may instead [use the new `drawTo` option][drawTo].

* Events have been renamed. `onChange`/`change` is now `drag`, and
  `onCommit`/`commit` is now `change`.

* Quinn's styling rules [have been changed][style-change]. If you use the
  default Quinn theme with no changes you should be able to simple drop the
  new stylesheet into your assets or public directory. If you customise the
  theme see the [above referenced commit][style-change] for more information.
  The `.active-bar` class has been renamed to `.delta-bar`.

* Quinn has been heavily refactored. Instead of a single class trying to do
  everything, there now exists a `Model` on which values are set, and is
  responsible for ensuring the values set are valid. A `Renderer` has been
  added which is solely responsible for creating the visual representation of
  the slider. The default Renderer creates the same HTML as before, but
  supplying your own renderer allows you to create completely custom sliders
  (you could even write a `CanvasRenderer` if you so desired).

* You may now use [more than two values][values] with Quinn.

* The Quinn instance is no longer attached to the DOM node using
  `jQuery.fn.data`. If you need to keep hold of the instance (for example, to
  alter the value elsewhere) you should use the constructor manually:

      new $.Quinn($('element'), options);
  {:class="no-example"}

* Two new events have been added: `enabled` and `disabled`, triggered when the
  slider is enabled and disabled.

* Since both jQuery and Backbone renamed their `bind` methods to `on`, Quinn
  has followed suit and done likewise.

      var quinn = new $.Quinn($('element'), options);

      quinn.on('drag',   function () { /* ... */ });
      quinn.on('change', function () { /* ... */ });
      quinn.on('abort',  function () { /* ... */ });
  {:class="no-example"}

* The internal methods `__willChange`, `__hasChanged`, and `__abortChange`
  have been renamed to `start`, `resolve`, and `reject` to more closely match
  the jQuery.Deferred API. Note that $.Quinn is *not* a jQuery.Deferred
  object; other Deferred methods are not provided.

* A couple of fixes to touchevents; Quinn will behave better on smartphones
  and tablets.

* Better positioning of the slider handles. The positioning of each handle is
  determined based on its radius, and the height of the slider bar to which it
  belongs. This results in better handling of custom CSS which has large
  handles.

#### 0.4.2 _February 10th, 2012_

Changed the way touch-support was detected to fix clicking on the handle not
working correctly in Chrome 17.

#### 0.4.1 _January 20th, 2012_

Fix for an occasional error when clicking on the bar of sliders when animation
is enabled.

#### 0.4.0 _December 8th, 2011_

Quinn ranges may now also represent a [range of values][values] by providing a
two-element array as the value option. Note that this will be the last major
Quinn release which will use the current "change" and "commit" callback names;
0.5 will change these to "drag" and "change" respectively.

#### 0.3.9 _October 4th, 2011_

During `onChange` callbacks, `quinn.value` will now be the new value of the
slider, and not the previous value.

#### 0.3.8 _September 29th, 2011_

Added `width` and `handleWidth` to manually set the width of these elements.
Useful when using Quinn on a wrapper element which hasn't yet been added to
the DOM.

#### 0.3.7 _August 18th, 2011_

Fix a bug with Firefox 6 where elements positioned absolutely with fractional
pixel values would not display correctly.

#### 0.3.6 _August 15th, 2011_

Fix a rendering error introduced in 0.3.4 where the blue active bar was placed
in the wrong position when both slider range values were above or below zero.

#### 0.3.5 _August 15th, 2011_

Some IE 8 fixes.

#### 0.3.4 _August 14th, 2011_

The blue "active bar" now originates at zero rather than the lowest slider
value, allowing sliders with sub-zero values to be better represented than
before.

#### 0.3.3 _July 28th, 2011_

Add a `disabledOpacity` option for controlling what opacity is used when
disabling.

#### 0.3.1 _July 21st, 2011_

Small stylesheet adjustment to ensure that the slider handle may be moved all
the way to the right of the bar.

#### 0.3.0 _June 27th, 2011_

Events may be bound to the Quinn instance just like DOM events in jQuery using
`bind`. The onComplete callback has been renamed onCommit.

#### 0.2.1 _June 14th, 2011_

Quinn has now been tested and fixed for IE7, urgh. Opera has been tested and,
unsurprisingly, works perfectly.

#### 0.2.0 _June 13th, 2011_

`stepUp` and `stepDown` have been added which are similar to the methods of
the same name on HTML 5 range and number inputs. Quinn instances may now be
created using `new $.Quinn(...)` if you need to hang on to the slider instance
after creation. Default theme changed to use a modified version of Aristo.
Fixed an issue when using `selectable` with `step` when the selectable options
didn't fit the step.

#### 0.1.6 _June 10th, 2011_

The `only` option has been added which restricts the choosable values to those
which are in the `only` array. Respects the `selectable` and `range` settings.
Clicking in the space above the visible slider bar now correctly triggers
events.

#### 0.1.4 _June 9th, 2011_

Adds support for touch devices (iOS, Android, etc). Various small fixes to
make the library "more jQuery-like", including the ability to chain other
functions off `$.fn.quinn()`. "Click-dragging" no longer fires two
`onComplete` events; only one when the user releases the mouse button.

#### 0.1.2 _June 9th, 2011_

When clicking on the slider bar, the mouse button may be held down to refine
the value by dragging the handle. The click and drag actions will fire
separate `onComplete` events.

#### 0.1.0 _June 8th, 2011_

Initial release on GitHub. Supports most planned features, but tests in Opera
and Internet Explorer are not yet complete.

[home]:           http://antw.github.com/quinn
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
[style-change]:   https://github.com/antw/quinn/commit/ea29f2f

[tarball]:        https://github.com/antw/quinn/tarball/v1.0.5
[development-js]: http://antw.github.com/quinn/jquery.quinn.js
[production-js]:  http://antw.github.com/quinn/jquery.quinn.min.js

[default-sprite]: http://antw.github.com/quinn/images/default.png
[rainbow-sprite]: http://antw.github.com/quinn/vendor/rainbow.png

[extrema]:        #extrema
[value]:          #value
[step]:           #step
[drawTo]:         #drawTo
[values]:         #values
[effects]:        #effects
[only]:           #only
[disable]:        #disable
[callbacks]:      #callbacks
[onsetup]:        #onsetup
[onbegin]:        #onbegin
[ondrag]:         #ondrag
[onchange]:       #onchange
[onabort]:        #onabort
[theming]:        #theming
[history]:        #history
