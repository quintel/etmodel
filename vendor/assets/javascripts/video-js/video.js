/*!
Video.js - HTML5 Video Player
Version 3.0.7

LGPL v3 LICENSE INFO
This file is part of Video.js. Copyright 2011 Zencoder, Inc.

Video.js is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Video.js is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Video.js.  If not, see <http://www.gnu.org/licenses/>.
*/

// Self-executing function to prevent global vars and help with minification
;(function(window, undefined){
  var document = window.document,
      CDN_VERSION = "3.0";// HTML5 Shiv. Must be in <head> to support older browsers.
document.createElement("video");document.createElement("audio");

var VideoJS = function(id, addOptions, ready){
  var tag; // Element of ID

  // Allow for element or ID to be passed in
  // String ID
  if (typeof id == "string") {

    // Adjust for jQuery ID syntax
    if (id.indexOf("#") === 0) {
      id = id.slice(1);
    }

    // If a player instance has already been created for this ID return it.
    if (_V_.players[id]) {
      return _V_.players[id];

    // Otherwise get element for ID
    } else {
      tag = _V_.el(id)
    }

  // ID is a media element
  } else {
    tag = id;
  }

  // Check for a useable element
  if (!tag || !tag.nodeName) { // re: nodeName, could be a box div also
    throw new TypeError("The element or ID supplied is not valid. (VideoJS)"); // Returns
  }

  // Element may have a player attr referring to an already created player instance.
  // If not, set up a new player and return the instance.
  return tag.player || new _V_.Player(tag, addOptions, ready);
},

// Shortcut
_V_ = VideoJS;

VideoJS.players = {};

VideoJS.options = {

  // Default order of fallback technology
  techOrder: ["html5","flash"],
  // techOrder: ["flash","html5"],

  html5: {},
  flash: {
    swf: "http://vjs.zencdn.net/c/video-js.swf"
  },

  // Default of web browser is 300x150. Should rely on source width/height.
  width: "auto",
  height: "auto",

  // defaultVolume: 0.85,
  defaultVolume: 0.00, // The freakin seaguls are driving me crazy!

  // Included control sets
  components: [
    "poster",
    "loadingSpinner",
    "bigPlayButton",
    { name: "controlBar", options: {
      components: [
        "playToggle",
        "fullscreenToggle",
        "currentTimeDisplay",
        "timeDivider",
        "durationDisplay",
        "remainingTimeDisplay",
        { name: "progressControl", options: {
          components: [
            { name: "seekBar", options: {
              components: [
                "loadProgressBar",
                "playProgressBar",
                "seekHandle"
              ]}
            }
          ]}
        },
        { name: "volumeControl", options: {
          components: [
            { name: "volumeBar", options: {
              components: [
                "volumeLevel",
                "volumeHandle"
              ]}
            }
          ]}
        },
        "muteToggle"
      ]
    }},
    "subtitlesDisplay"/*, "replay"*/
  ]
};

// Set CDN Version of swf
if (CDN_VERSION != "GENERATED_CDN_VSN") {
  _V_.options.flash.swf = "http://vjs.zencdn.net/"+CDN_VERSION+"/video-js.swf"
}

// Automatically set up any tags that have a data-setup attribute
_V_.autoSetup = function(){
  var options, vid, player,
      vids = document.getElementsByTagName("video");

  // Check if any media elements exist
  if (vids && vids.length > 0) {

    for (var i=0,j=vids.length; i<j; i++) {
      vid = vids[i];

      // Check if element exists, has getAttribute func.
      // IE seems to consider typeof el.getAttribute == "object" instead of "function" like expected, at least when loading the player immediately.
      if (vid && vid.getAttribute) {

        // Make sure this player hasn't already been set up.
        if (vid.player === undefined) {
          options = vid.getAttribute("data-setup");

          // Check if data-setup attr exists.
          // We only auto-setup if they've added the data-setup attr.
          if (options !== null) {

            // Parse options JSON
            // If empty string, make it a parsable json object.
            options = JSON.parse(options || "{}");

            // Create new video.js instance.
            player = _V_(vid, options);
          }
        }

      // If getAttribute isn't defined, we need to wait for the DOM.
      } else {
        _V_.autoSetupTimeout(1);
        break;
      }
    }

  // No videos were found, so keep looping unless page is finisehd loading.
  } else if (!_V_.windowLoaded) {
    _V_.autoSetupTimeout(1);
  }
};

// Pause to let the DOM keep processing
_V_.autoSetupTimeout = function(wait){
  setTimeout(_V_.autoSetup, wait);
};
_V_.merge = function(obj1, obj2, safe){
  // Make sure second object exists
  if (!obj2) { obj2 = {}; };

  for (var attrname in obj2){
    if (obj2.hasOwnProperty(attrname) && (!safe || !obj1.hasOwnProperty(attrname))) { obj1[attrname]=obj2[attrname]; }
  }
  return obj1;
};
_V_.extend = function(obj){ this.merge(this, obj, true); };

_V_.extend({
  tech: {}, // Holder for playback technology settings
  controlSets: {}, // Holder for control set definitions

  // Device Checks
  isIE: function(){ return !+"\v1"; },
  isIPad: function(){ return navigator.userAgent.match(/iPad/i) !== null; },
  isIPhone: function(){ return navigator.userAgent.match(/iPhone/i) !== null; },
  isIOS: function(){ return VideoJS.isIPhone() || VideoJS.isIPad(); },
  iOSVersion: function() {
    var match = navigator.userAgent.match(/OS (\d+)_/i);
    if (match && match[1]) { return match[1]; }
  },
  isAndroid: function(){ return navigator.userAgent.match(/Android.*AppleWebKit/i) !== null; },
  androidVersion: function() {
    var match = navigator.userAgent.match(/Android (\d+)\./i);
    if (match && match[1]) { return match[1]; }
  },

  testVid: document.createElement("video"),
  ua: navigator.userAgent,
  support: {},

  each: function(arr, fn){
    if (!arr || arr.length === 0) { return; }
    for (var i=0,j=arr.length; i<j; i++) {
      fn.call(this, arr[i], i);
    }
  },

  el: function(id){ return document.getElementById(id); },
  createElement: function(tagName, attributes){
    var el = document.createElement(tagName),
        attrname;
    for (attrname in attributes){
      if (attributes.hasOwnProperty(attrname)) {
        if (attrname.indexOf("-") !== -1) {
          el.setAttribute(attrname, attributes[attrname]);
        } else {
          el[attrname] = attributes[attrname];
        }
      }
    }
    return el;
  },

  insertFirst: function(node, parent){
    if (parent.firstChild) {
      parent.insertBefore(node, parent.firstChild);
    } else {
      parent.appendChild(node);
    }
  },

  addClass: function(element, classToAdd){
    if ((" "+element.className+" ").indexOf(" "+classToAdd+" ") == -1) {
      element.className = element.className === "" ? classToAdd : element.className + " " + classToAdd;
    }
  },

  removeClass: function(element, classToRemove){
    if (element.className.indexOf(classToRemove) == -1) { return; }
    var classNames = element.className.split(" ");
    classNames.splice(classNames.indexOf(classToRemove),1);
    element.className = classNames.join(" ");
  },

  remove: function(item, array){
    if (!array) return;
    var i = array.indexOf(item);
    if (i != -1) {
      return array.splice(i, 1)
    };
  },

  // Attempt to block the ability to select text while dragging controls
  blockTextSelection: function(){
    document.body.focus();
    document.onselectstart = function () { return false; };
  },
  // Turn off text selection blocking
  unblockTextSelection: function(){ document.onselectstart = function () { return true; }; },

  // Return seconds as H:MM:SS or M:SS
  // Supplying a guide (in seconds) will include enough leading zeros to cover the length of the guide
  formatTime: function(seconds, guide) {
    var guide = guide || seconds, // Default to using seconds as guide
        s = Math.floor(seconds % 60),
        m = Math.floor(seconds / 60 % 60),
        h = Math.floor(seconds / 3600),
        gm = Math.floor(guide / 60 % 60),
        gh = Math.floor(guide / 3600);

    // Check if we need to show hours
    h = (h > 0 || gh > 0) ? h + ":" : "";

    // If hours are showing, we may need to add a leading zero.
    // Always show at least one digit of minutes.
    m = (((h || gm >= 10) && m < 10) ? "0" + m : m) + ":";

    // Check if leading zero is need for seconds
    s = (s < 10) ? "0" + s : s;

    return h + m + s;
  },

  capitalize: function(string){
    return string.charAt(0).toUpperCase() + string.slice(1);
  },

  // Return the relative horizonal position of an event as a value from 0-1
  getRelativePosition: function(x, relativeElement){
    return Math.max(0, Math.min(1, (x - _V_.findPosX(relativeElement)) / relativeElement.offsetWidth));
  },

  getComputedStyleValue: function(element, style){
    return window.getComputedStyle(element, null).getPropertyValue(style);
  },

  trim: function(string){ return string.toString().replace(/^\s+/, "").replace(/\s+$/, ""); },
  round: function(num, dec) {
    if (!dec) { dec = 0; }
    return Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
  },

  isEmpty: function(object) {
    for (var prop in object) {
      return false;
    }
    return true;
  },

  // Mimic HTML5 TimeRange Spec.
  createTimeRange: function(start, end){
    return {
      length: 1,
      start: function() { return start; },
      end: function() { return end; }
    };
  },

  /* Element Data Store. Allows for binding data to an element without putting it directly on the element.
     Ex. Event listneres are stored here.
     (also from jsninja.com)
  ================================================================================ */
  cache: {}, // Where the data is stored
  guid: 1, // Unique ID for the element
  expando: "vdata" + (new Date).getTime(), // Unique attribute to store element's guid in

  // Returns the cache object where data for the element is stored
  getData: function(elem){
    var id = elem[_V_.expando];
    if (!id) {
      id = elem[_V_.expando] = _V_.guid++;
      _V_.cache[id] = {};
    }
    return _V_.cache[id];
  },
  // Delete data for the element from the cache and the guid attr from element
  removeData: function(elem){
    var id = elem[_V_.expando];
    if (!id) { return; }
    // Remove all stored data
    delete _V_.cache[id];
    // Remove the expando property from the DOM node
    try {
      delete elem[_V_.expando];
    } catch(e) {
      if (elem.removeAttribute) {
        elem.removeAttribute(_V_.expando);
      } else {
        // IE doesn't appear to support removeAttribute on the document element
        elem[_V_.expando] = null;
      }
    }
  },

  /* Proxy (a.k.a Bind or Context). A simple method for changing the context of a function
     It also stores a unique id on the function so it can be easily removed from events
  ================================================================================ */
  proxy: function(context, fn) {
    // Make sure the function has a unique ID
    if (!fn.guid) { fn.guid = _V_.guid++; }
    // Create the new function that changes the context
    var ret = function() {
      return fn.apply(context, arguments);
    };

    // Give the new function the same ID
    // (so that they are equivalent and can be easily removed)
    ret.guid = fn.guid;

    return ret;
  },

  get: function(url, onSuccess, onError){
    // if (netscape.security.PrivilegeManager.enablePrivilege) {
    //   netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
    // }

    var local = (url.indexOf("file:") == 0 || (window.location.href.indexOf("file:") == 0 && url.indexOf("http:") == -1));

    if (typeof XMLHttpRequest == "undefined") {
      XMLHttpRequest = function () {
        try { return new ActiveXObject("Msxml2.XMLHTTP.6.0"); } catch (e) {}
        try { return new ActiveXObject("Msxml2.XMLHTTP.3.0"); } catch (f) {}
        try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (g) {}
        throw new Error("This browser does not support XMLHttpRequest.");
      };
    }

    var request = new XMLHttpRequest();

    try {
      request.open("GET", url);
    } catch(e) {
      _V_.log("VideoJS XMLHttpRequest (open)", e);
      // onError(e);
      return false;
    }

    request.onreadystatechange = _V_.proxy(this, function() {
      if (request.readyState == 4) {
        if (request.status == 200 || local && request.status == 0) {
          onSuccess(request.responseText);
        } else {
          if (onError) {
            onError();
          }
        }
      }
    });

    try {
      request.send();
    } catch(e) {
      _V_.log("VideoJS XMLHttpRequest (send)", e);
      if (onError) {
        onError(e);
      }
    }
  },

  /* Local Storage
  ================================================================================ */
  setLocalStorage: function(key, value){
    // IE was throwing errors referencing the var anywhere without this
    var localStorage = localStorage || false;
    if (!localStorage) { return; }
    try {
      localStorage[key] = value;
    } catch(e) {
      if (e.code == 22 || e.code == 1014) { // Webkit == 22 / Firefox == 1014
        _V_.log("LocalStorage Full (VideoJS)", e);
      } else {
        _V_.log("LocalStorage Error (VideoJS)", e);
      }
    }
  }

});

// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
_V_.log = function(){
  _V_.log.history = _V_.log.history || [];// store logs to an array for reference
  _V_.log.history.push(arguments);
  if(window.console) {
    arguments.callee = arguments.callee.caller;
    var newarr = [].slice.call(arguments);
    (typeof console.log === 'object' ? _V_.log.apply.call(console.log, console, newarr) : console.log.apply(console, newarr));
  }
};

// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
{console.log();return window.console;}catch(err){return window.console={};}})());

// Offset Left
// getBoundingClientRect technique from John Resig http://ejohn.org/blog/getboundingclientrect-is-awesome/
if ("getBoundingClientRect" in document.documentElement) {
  _V_.findPosX = function(el) {
    var box;

    try {
      box = el.getBoundingClientRect();
    } catch(e) {}

    if (!box) { return 0; }

    var docEl = document.documentElement,
        body = document.body,
        clientLeft = docEl.clientLeft || body.clientLeft || 0,
        scrollLeft = window.pageXOffset || body.scrollLeft,
        left = box.left + scrollLeft - clientLeft;

    return left;
  };
} else {
  _V_.findPosX = function(el) {
    var curleft = el.offsetLeft;
    // _V_.log(obj.className, obj.offsetLeft)
    while(el = obj.offsetParent) {
      if (el.className.indexOf("video-js") == -1) {
        // _V_.log(el.offsetParent, "OFFSETLEFT", el.offsetLeft)
        // _V_.log("-webkit-full-screen", el.webkitMatchesSelector("-webkit-full-screen"));
        // _V_.log("-webkit-full-screen", el.querySelectorAll(".video-js:-webkit-full-screen"));
      } else {
      }
      curleft += el.offsetLeft;
    }
    return curleft;
  };
}// Using John Resig's Class implementation http://ejohn.org/blog/simple-javascript-inheritance/
// (function(){var initializing=false, fnTest=/xyz/.test(function(){xyz;}) ? /\b_super\b/ : /.*/; _V_.Class = function(){}; _V_.Class.extend = function(prop) { var _super = this.prototype; initializing = true; var prototype = new this(); initializing = false; for (var name in prop) { prototype[name] = typeof prop[name] == "function" && typeof _super[name] == "function" && fnTest.test(prop[name]) ? (function(name, fn){ return function() { var tmp = this._super; this._super = _super[name]; var ret = fn.apply(this, arguments); this._super = tmp; return ret; }; })(name, prop[name]) : prop[name]; } function Class() { if ( !initializing && this.init ) this.init.apply(this, arguments); } Class.prototype = prototype; Class.constructor = Class; Class.extend = arguments.callee; return Class;};})();
(function(){
  var initializing = false, fnTest = /xyz/.test(function(){xyz;}) ? /\b_super\b/ : /.*/;
  _V_.Class = function(){};
  _V_.Class.extend = function(prop) {
    var _super = this.prototype;
    initializing = true;
    var prototype = new this();
    initializing = false;
    for (var name in prop) {
      prototype[name] = typeof prop[name] == "function" &&
        typeof _super[name] == "function" && fnTest.test(prop[name]) ?
        (function(name, fn){
          return function() {
            var tmp = this._super;
            this._super = _super[name];
            var ret = fn.apply(this, arguments);
            this._super = tmp;
            return ret;
          };
        })(name, prop[name]) :
        prop[name];
    }
    function Class() {
      if ( !initializing && this.init ) {
        return this.init.apply(this, arguments);

      // Attempting to recreate accessing function form of class.
      } else if (!initializing) {
        return arguments.callee.prototype.init()
      }
    }
    Class.prototype = prototype;
    Class.constructor = Class;
    Class.extend = arguments.callee;
    return Class;
  };
})();

/* Player Component- Base class for all UI objects
================================================================================ */
_V_.Component = _V_.Class.extend({

  init: function(player, options){
    this.player = player;

    if (options && options.el) {
      this.el = options.el;
    } else {
      this.el = this.createElement();
    }

    // Array of sub-components
    if (options && options.components) {
      _V_.each.call(this, options.components, function(comp){
        this.addComponent(comp);
      });
    }
  },

  destroy: function(){},

  createElement: function(type, attrs){
    return _V_.createElement(type || "div", attrs);
  },

  buildCSSClass: function(){
    // Child classes can include a function that does:
    // return "CLASS NAME" + this._super();
    return "";
  },

  // Add child components to this component.
  // Will generate a new child component and then append child component's element to this component's element.
  // Takes either the name of the UI component class, or an object that contains a name, UI Class, and options.
  addComponent: function(nameORobj){
    var name, componentClass, options, component;

    if (typeof nameORobj == "string") {
      name = nameORobj;

    // Can also pass in object to define a different class than the name and add other options
    } else {
      name = nameORobj.name;
      componentClass = nameORobj.componentClass;
      options = nameORobj.options;
    }

    if (!componentClass) {
      // Assume name of set is a lowercased name of the UI Class (PlayButton, etc.)
      componentClass = _V_.capitalize(name);
    }

    // Create a new object & element for this controls set
    // If there's no .player, this is a player
    component = new _V_[componentClass](this.player || this, options);

    if (this.components === undefined) {
      this.components = [];
    }
    this.components.push(component);

    // Add the UI object's element to the container div (box)
    this.el.appendChild(component.el);
  },

  /* Display
  ================================================================================ */
  show: function(){
    this.el.style.display = "block";
  },

  hide: function(){
    this.el.style.display = "none";
  },

  addClass: function(classToAdd){
    _V_.addClass(this.el, classToAdd);
  },

  removeClass: function(classToRemove){
    _V_.removeClass(this.el, classToRemove);
  },

  /* Events
  ================================================================================ */
  addEvent: function(type, fn){
    return _V_.addEvent(this.el, type, _V_.proxy(this, fn));
  },
  removeEvent: function(type, fn){
    return _V_.removeEvent(this.el, type, fn);
  },
  triggerEvent: function(type, e){
    return _V_.triggerEvent(this.el, type, e);
  },

  /* Ready - Trigger functions when component is ready
  ================================================================================ */
  ready: function(fn){
    if (!fn) return this;

    if (this.isReady) {
      fn.call(this);
    } else {
      if (this.readyQueue === undefined) {
        this.readyQueue = [];
      }
      this.readyQueue.push(fn);
    }

    return this;
  },

  triggerReady: function(){
    this.isReady = true;
    if (this.readyQueue && this.readyQueue.length > 0) {
      // Call all functions in ready queue
      this.each(this.readyQueue, function(fn){
        fn.call(this);
      });

      // Reset Ready Queue
      this.readyQueue = [];
    }
  },

  /* Utility
  ================================================================================ */
  each: function(arr, fn){
    if (!arr || arr.length === 0) { return; }
    for (var i=0,j=arr.length; i<j; i++) {
      if (fn.call(this, arr[i], i)) { break; }
    }
  },

  extend: function(obj){
    for (var attrname in obj) {
      if (obj.hasOwnProperty(attrname)) { this[attrname]=obj[attrname]; }
    }
  },

  // More easily attach 'this' to functions
  proxy: function(fn){
    return _V_.proxy(this, fn);
  }

});/* Control - Base class for all control elements
================================================================================ */
_V_.Control = _V_.Component.extend({

  buildCSSClass: function(){
    return "vjs-control " + this._super();
  }

});

/* Button - Base class for all buttons
================================================================================ */
_V_.Button = _V_.Control.extend({

  init: function(player, options){
    this._super(player, options);

    this.addEvent("click", this.onClick);
    this.addEvent("focus", this.onFocus);
    this.addEvent("blur", this.onBlur);
  },

  createElement: function(type, attrs){
    // Add standard Aria and Tabindex info
    attrs = _V_.merge({
      className: this.buildCSSClass(),
      innerHTML: '<div><span class="vjs-control-text">' + (this.buttonText || "Need Text") + '</span></div>',
      role: "button",
      tabIndex: 0
    }, attrs);

    return this._super(type, attrs);
  },

  // Click - Override with specific functionality for button
  onClick: function(){},

  // Focus - Add keyboard functionality to element
  onFocus: function(){
    _V_.addEvent(document, "keyup", _V_.proxy(this, this.onKeyPress));
  },

  // KeyPress (document level) - Trigger click when keys are pressed
  onKeyPress: function(event){
    // Check for space bar (32) or enter (13) keys
    if (event.which == 32 || event.which == 13) {
      event.preventDefault();
      this.onClick();
    }
  },

  // Blur - Remove keyboard triggers
  onBlur: function(){
    _V_.removeEvent(document, "keyup", _V_.proxy(this, this.onKeyPress));
  }

});

/* Play Button
================================================================================ */
_V_.PlayButton = _V_.Button.extend({

  buttonText: "Play",

  buildCSSClass: function(){
    return "vjs-play-button " + this._super();
  },

  onClick: function(){
    this.player.play();
  }

});

/* Pause Button
================================================================================ */
_V_.PauseButton = _V_.Button.extend({

  buttonText: "Pause",

  buildCSSClass: function(){
    return "vjs-pause-button " + this._super();
  },

  onClick: function(){
    this.player.pause();
  }

});

/* Play Toggle - Play or Pause Media
================================================================================ */
_V_.PlayToggle = _V_.Button.extend({

  buttonText: "Play",

  init: function(player, options){
    this._super(player, options);

    player.addEvent("play", _V_.proxy(this, this.onPlay));
    player.addEvent("pause", _V_.proxy(this, this.onPause));
  },

  buildCSSClass: function(){
    return "vjs-play-control " + this._super();
  },

  // OnClick - Toggle between play and pause
  onClick: function(){
    if (this.player.paused()) {
      this.player.play();
    } else {
      this.player.pause();
    }
  },

  // OnPlay - Add the vjs-playing class to the element so it can change appearance
  onPlay: function(){
    _V_.removeClass(this.el, "vjs-paused");
    _V_.addClass(this.el, "vjs-playing");
  },

  // OnPause - Add the vjs-paused class to the element so it can change appearance
  onPause: function(){
    _V_.removeClass(this.el, "vjs-playing");
    _V_.addClass(this.el, "vjs-paused");
  }

});


/* Fullscreen Toggle Behaviors
================================================================================ */
_V_.FullscreenToggle = _V_.Button.extend({

  buttonText: "Fullscreen",

  buildCSSClass: function(){
    return "vjs-fullscreen-control " + this._super();
  },

  onClick: function(){
    if (!this.player.videoIsFullScreen) {
      this.player.requestFullScreen();
    } else {
      this.player.cancelFullScreen();
    }
  }

});

/* Big Play Button
================================================================================ */
_V_.BigPlayButton = _V_.Button.extend({
  init: function(player, options){
    this._super(player, options);

    player.addEvent("play", _V_.proxy(this, this.hide));
    player.addEvent("ended", _V_.proxy(this, this.show));
  },

  createElement: function(){
    return this._super("div", {
      className: "vjs-big-play-button",
      innerHTML: "<span></span>"
    });
  },

  onClick: function(){
    // Go back to the beginning if big play button is showing at the end.
    // Have to check for current time otherwise it might throw a 'not ready' error.
    if(this.player.currentTime()) {
      this.player.currentTime(0);
    }
    this.player.play();
  }
});

/* Loading Spinner
================================================================================ */
_V_.LoadingSpinner = _V_.Component.extend({
  init: function(player, options){
    this._super(player, options);

    player.addEvent("canplay", _V_.proxy(this, this.hide));
    player.addEvent("canplaythrough", _V_.proxy(this, this.hide));
    player.addEvent("playing", _V_.proxy(this, this.hide));

    player.addEvent("seeking", _V_.proxy(this, this.show));
    player.addEvent("error", _V_.proxy(this, this.show));
    player.addEvent("stalled", _V_.proxy(this, this.show));
    player.addEvent("waiting", _V_.proxy(this, this.show));
  },

  createElement: function(){

    var classNameSpinner, innerHtmlSpinner;

    if ( typeof this.player.el.style.WebkitBorderRadius == "string"
         || typeof this.player.el.style.MozBorderRadius == "string"
         || typeof this.player.el.style.KhtmlBorderRadius == "string"
         || typeof this.player.el.style.borderRadius == "string")
      {
        classNameSpinner = "vjs-loading-spinner";
        innerHtmlSpinner = "<div class='ball1'></div><div class='ball2'></div><div class='ball3'></div><div class='ball4'></div><div class='ball5'></div><div class='ball6'></div><div class='ball7'></div><div class='ball8'></div>";
      } else {
        classNameSpinner = "vjs-loading-spinner-fallback";
        innerHtmlSpinner = "";
      }

    return this._super("div", {
      className: classNameSpinner,
      innerHTML: innerHtmlSpinner
    });
  }
});

/* Control Bar
================================================================================ */
_V_.ControlBar = _V_.Component.extend({
  init: function(player, options){
    this._super(player, options);

    player.addEvent("play", this.proxy(this.show));

    player.addEvent("mouseover", this.proxy(this.reveal));
    player.addEvent("mouseout", this.proxy(this.conceal));
  },

  createElement: function(){
    return _V_.createElement("div", {
      className: "vjs-controls"
    });
  },

  // Used for transitions (fading out)
  reveal: function(){
    this.el.style.opacity = 1;
  },

  conceal: function(){
    this.el.style.opacity = 0;
  }
});

/* Time
================================================================================ */
_V_.CurrentTimeDisplay = _V_.Component.extend({

  init: function(player, options){
    this._super(player, options);

    player.addEvent("timeupdate", _V_.proxy(this, this.updateContent));
  },

  createElement: function(){
    var el = this._super("div", {
      className: "vjs-current-time vjs-time-controls vjs-control"
    });

    this.content = _V_.createElement("div", {
      className: "vjs-current-time-display",
      innerHTML: '0:00'
    });

    el.appendChild(_V_.createElement("div").appendChild(this.content));
    return el;
  },

  updateContent: function(){
    // Allows for smooth scrubbing, when player can't keep up.
    var time = (this.player.scrubbing) ? this.player.values.currentTime : this.player.currentTime();
    this.content.innerHTML = _V_.formatTime(time, this.player.duration());
  }

});

_V_.DurationDisplay = _V_.Component.extend({

  init: function(player, options){
    this._super(player, options);

    player.addEvent("timeupdate", _V_.proxy(this, this.updateContent));
  },

  createElement: function(){
    var el = this._super("div", {
      className: "vjs-duration vjs-time-controls vjs-control"
    });

    this.content = _V_.createElement("div", {
      className: "vjs-duration-display",
      innerHTML: '0:00'
    });

    el.appendChild(_V_.createElement("div").appendChild(this.content));
    return el;
  },

  updateContent: function(){
    if (this.player.duration()) { this.content.innerHTML = _V_.formatTime(this.player.duration()); }
  }

});

// Time Separator (Not used in main skin, but still available, and could be used as a 'spare element')
_V_.TimeDivider = _V_.Component.extend({

  createElement: function(){
    return this._super("div", {
      className: "vjs-time-divider",
      innerHTML: '<div><span>/</span></div>'
    });
  }

});

_V_.RemainingTimeDisplay = _V_.Component.extend({

  init: function(player, options){
    this._super(player, options);

    player.addEvent("timeupdate", _V_.proxy(this, this.updateContent));
  },

  createElement: function(){
    var el = this._super("div", {
      className: "vjs-remaining-time vjs-time-controls vjs-control"
    });

    this.content = _V_.createElement("div", {
      className: "vjs-remaining-time-display",
      innerHTML: '-0:00'
    });

    el.appendChild(_V_.createElement("div").appendChild(this.content));
    return el;
  },

  updateContent: function(){
    if (this.player.duration()) { this.content.innerHTML = "-"+_V_.formatTime(this.player.remainingTime()); }

    // Allows for smooth scrubbing, when player can't keep up.
    // var time = (this.player.scrubbing) ? this.player.values.currentTime : this.player.currentTime();
    // this.content.innerHTML = _V_.formatTime(time, this.player.duration());
  }

});

/* Slider - Parent for seek bar and volume slider
================================================================================ */
_V_.Slider = _V_.Component.extend({

  init: function(player, options){
    this._super(player, options);

    _V_.each.call(this, this.components, function(comp){
      if (comp instanceof _V_[this.barClass]) {
        this.bar = comp;
      } else if (comp instanceof _V_[this.handleClass]) {
        this.handle = comp;
      }
    });

    player.addEvent(this.playerEvent, _V_.proxy(this, this.update));

    this.addEvent("mousedown", this.onMouseDown);
    this.addEvent("focus", this.onFocus);
    this.addEvent("blur", this.onBlur);

    // Update Display
    // Need to wait for styles to be loaded.
    // TODO - replace setTimeout with stylesReady function.
    setTimeout(this.proxy(this.update), 0);
  },

  createElement: function(type, attrs) {
    attrs = _V_.merge({
      role: "slider",
      "aria-valuenow": 0,
      "aria-valuemin": 0,
      "aria-valuemax": 100,
      tabIndex: 0
    }, attrs);

    return this._super(type, attrs);
  },

  onMouseDown: function(event){
    event.preventDefault();
    _V_.blockTextSelection();

    _V_.addEvent(document, "mousemove", _V_.proxy(this, this.onMouseMove));
    _V_.addEvent(document, "mouseup", _V_.proxy(this, this.onMouseUp));

    this.onMouseMove(event);
  },

  onMouseUp: function(event) {
    _V_.unblockTextSelection();
    _V_.removeEvent(document, "mousemove", this.onMouseMove, false);
    _V_.removeEvent(document, "mouseup", this.onMouseUp, false);

    this.update();
  },

  update: function(){
    // If scrubbing, we could use a cached value to make the handle keep up with the user's mouse.
    // On HTML5 browsers scrubbing is really smooth, but some flash players are slow, so we might want to utilize this later.
    // var progress =  (this.player.scrubbing) ? this.player.values.currentTime / this.player.duration() : this.player.currentTime() / this.player.duration();

    var barProgress,
        progress = this.getPercent();
        handle = this.handle,
        bar = this.bar;

    // Protect against no duration and other division issues
    if (isNaN(progress)) { progress = 0; }

    barProgress = progress;

    // If there is a handle, we need to account for the handle in our calculation for progress bar
    // so that it doesn't fall short of or extend past the handle.
    if (handle) {
      var box = this.el,
          boxWidth = box.offsetWidth,

          // The width of the handle in percent of the containing box
          // In IE, widths may not be ready yet causing NaN
          handlePercent = (handle.el.offsetWidth) ? handle.el.offsetWidth / boxWidth : 0,

          // Get the adjusted size of the box, considering that the handle's center never touches the left or right side.
          // There is a margin of half the handle's width on both sides.
          boxAdjustedPercent = 1 - handlePercent;

          // Adjust the progress that we'll use to set widths to the new adjusted box width
          adjustedProgress = progress * boxAdjustedPercent,

          // The bar does reach the left side, so we need to account for this in the bar's width
          barProgress = adjustedProgress + (handlePercent / 2);

      // Move the handle from the left based on the adjected progress
      handle.el.style.left = _V_.round(adjustedProgress * 100, 2) + "%";
    }

    // Set the new bar width
    bar.el.style.width = _V_.round(barProgress * 100, 2) + "%";
  },

  calculateDistance: function(event){
    var box = this.el,
        boxX = _V_.findPosX(box),
        boxW = box.offsetWidth,
        handle = this.handle;

    if (handle) {
      var handleW = handle.el.offsetWidth;

      // Adjusted X and Width, so handle doesn't go outside the bar
      boxX = boxX + (handleW / 2);
      boxW = boxW - handleW;
    }

    // Percent that the click is through the adjusted area
    return Math.max(0, Math.min(1, (event.pageX - boxX) / boxW));
  },

  onFocus: function(event){
    _V_.addEvent(document, "keyup", _V_.proxy(this, this.onKeyPress));
  },

  onKeyPress: function(event){
    if (event.which == 37) { // Left Arrow
      event.preventDefault();
      this.stepBack();
    } else if (event.which == 39) { // Right Arrow
      event.preventDefault();
      this.stepForward();
    }
  },

  onBlur: function(event){
    _V_.removeEvent(document, "keyup", _V_.proxy(this, this.onKeyPress));
  }
});


/* Progress
================================================================================ */

// Progress Control: Seek, Load Progress, and Play Progress
_V_.ProgressControl = _V_.Component.extend({

  createElement: function(){
    return this._super("div", {
      className: "vjs-progress-control vjs-control"
    });
  }

});

// Seek Bar and holder for the progress bars
_V_.SeekBar = _V_.Slider.extend({

  barClass: "PlayProgressBar",
  handleClass: "SeekHandle",
  playerEvent: "timeupdate",

  init: function(player, options){
    this._super(player, options);
  },

  createElement: function(){
    return this._super("div", {
      className: "vjs-progress-holder"
    });
  },

  getPercent: function(){
    return this.player.currentTime() / this.player.duration();
  },

  onMouseDown: function(event){
    this._super(event);

    this.player.scrubbing = true;

    this.videoWasPlaying = !this.player.paused();
    this.player.pause();
  },

  onMouseMove: function(event){
    var newTime = this.calculateDistance(event) * this.player.duration();

    // Don't let video end while scrubbing.
    if (newTime == this.player.duration()) { newTime = newTime - 0.1; }

    // Set new time (tell player to seek to new time)
    this.player.currentTime(newTime);
  },

  onMouseUp: function(event){
    this._super(event);

    this.player.scrubbing = false;
    if (this.videoWasPlaying) {
      this.player.play();
    }
  },

  stepForward: function(){
    this.player.currentTime(this.player.currentTime() + 1);
  },

  stepBack: function(){
    this.player.currentTime(this.player.currentTime() - 1);
  }

});

// Load Progress Bar
_V_.LoadProgressBar = _V_.Component.extend({

  init: function(player, options){
    this._super(player, options);
    player.addEvent("progress", _V_.proxy(this, this.update));
  },

  createElement: function(){
    return this._super("div", {
      className: "vjs-load-progress",
      innerHTML: '<span class="vjs-control-text">Loaded: 0%</span>'
    });
  },

  update: function(){
    if (this.el.style) { this.el.style.width = _V_.round(this.player.bufferedPercent() * 100, 2) + "%"; }
  }

});

// Play Progress Bar
_V_.PlayProgressBar = _V_.Component.extend({

  createElement: function(){
    return this._super("div", {
      className: "vjs-play-progress",
      innerHTML: '<span class="vjs-control-text">Progress: 0%</span>'
    });
  }

});

// Seek Handle
// SeekBar Behavior includes play progress bar, and seek handle
// Needed so it can determine seek position based on handle position/size
_V_.SeekHandle = _V_.Component.extend({

  createElement: function(){
    return this._super("div", {
      className: "vjs-seek-handle",
      innerHTML: '<span class="vjs-control-text">00:00</span>'
    });
  }

});

/* Volume Scrubber
================================================================================ */
// Progress Control: Seek, Load Progress, and Play Progress
_V_.VolumeControl = _V_.Component.extend({

  createElement: function(){
    return this._super("div", {
      className: "vjs-volume-control vjs-control"
    });
  }

});

_V_.VolumeBar = _V_.Slider.extend({

  barClass: "VolumeLevel",
  handleClass: "VolumeHandle",
  playerEvent: "volumechange",

  createElement: function(){
    return this._super("div", {
      className: "vjs-volume-bar"
    });
  },

  onMouseMove: function(event) {
    this.player.volume(this.calculateDistance(event));
  },

  getPercent: function(){
   return this.player.volume();
  },

  stepForward: function(){
    this.player.volume(this.player.volume() + 0.1);
  },

  stepBack: function(){
    this.player.volume(this.player.volume() - 0.1);
  }
});

_V_.VolumeLevel = _V_.Component.extend({

  createElement: function(){
    return this._super("div", {
      className: "vjs-volume-level",
      innerHTML: '<span class="vjs-control-text"></span>'
    });
  }

});

_V_.VolumeHandle = _V_.Component.extend({

  createElement: function(){
    return this._super("div", {
      className: "vjs-volume-handle",
      innerHTML: '<span class="vjs-control-text"></span>'
      // tabindex: 0,
      // role: "slider", "aria-valuenow": 0, "aria-valuemin": 0, "aria-valuemax": 100
    });
  }

});

_V_.MuteToggle = _V_.Button.extend({

  init: function(player, options){
    this._super(player, options);

    player.addEvent("volumechange", _V_.proxy(this, this.update));
  },

  createElement: function(){
    return this._super("div", {
      className: "vjs-mute-control vjs-control",
      innerHTML: '<div><span class="vjs-control-text">Mute</span></div>'
    });
  },

  onClick: function(event){
    this.player.muted( this.player.muted() ? false : true );
  },

  update: function(event){
    var vol = this.player.volume(),
        level = 3;

    if (vol == 0 || this.player.muted()) {
      level = 0;
    } else if (vol < 0.33) {
      level = 1;
    } else if (vol < 0.67) {
      level = 2;
    }

    /* TODO improve muted icon classes */
    _V_.each.call(this, [0,1,2,3], function(i){
      _V_.removeClass(this.el, "vjs-vol-"+i);
    });
    _V_.addClass(this.el, "vjs-vol-"+level);
  }

});


/* Poster Image
================================================================================ */
_V_.Poster = _V_.Button.extend({
  init: function(player, options){
    this._super(player, options);

    if (!this.player.options.poster) {
      this.hide();
    }

    player.addEvent("play", _V_.proxy(this, this.hide));
  },

  createElement: function(){
    return _V_.createElement("img", {
      className: "vjs-poster",
      src: this.player.options.poster,

      // Don't want poster to be tabbable.
      tabIndex: -1
    });
  },

  onClick: function(){
    this.player.play();
  }
});


/* Text Track Displays
================================================================================ */
// Create a behavior type for each text track type (subtitlesDisplay, captionsDisplay, etc.).
// Then you can easily do something like.
//    player.addBehavior(myDiv, "subtitlesDisplay");
// And the myDiv's content will be updated with the text change.

// Base class for all track displays. Should not be instantiated on its own.
_V_.TextTrackDisplay = _V_.Component.extend({

  init: function(player, options){
    this._super(player, options);

    player.addEvent(this.trackType + "update", _V_.proxy(this, this.update));
  },

  createElement: function(){
    return this._super("div", {
      className: "vjs-" + this.trackType
    });
  },

  update: function(){
    this.el.innerHTML = this.player.textTrackValue(this.trackType);
  }

});

_V_.SubtitlesDisplay = _V_.TextTrackDisplay.extend({

  trackType: "subtitles"

});

_V_.CaptionsDisplay = _V_.TextTrackDisplay.extend({

  trackType: "captions"

});

_V_.ChaptersDisplay = _V_.TextTrackDisplay.extend({

  trackType: "chapters"

});

_V_.DescriptionsDisplay = _V_.TextTrackDisplay.extend({

  trackType: "descriptions"

});// ECMA-262 is the standard for javascript.
// The following methods are impelemented EXACTLY as described in the standard (according to Mozilla Docs), and do not override the default method if one exists.
// This may conflict with other libraries that modify the array prototype, but those libs should update to use the standard.

// [].indexOf
// https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/indexOf
if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function (searchElement /*, fromIndex */ ) {
        "use strict";
        if (this === void 0 || this === null) {
            throw new TypeError();
        }
        var t = Object(this);
        var len = t.length >>> 0;
        if (len === 0) {
            return -1;
        }
        var n = 0;
        if (arguments.length > 0) {
            n = Number(arguments[1]);
            if (n !== n) { // shortcut for verifying if it's NaN
                n = 0;
            } else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0)) {
                n = (n > 0 || -1) * Math.floor(Math.abs(n));
            }
        }
        if (n >= len) {
            return -1;
        }
        var k = n >= 0 ? n : Math.max(len - Math.abs(n), 0);
        for (; k < len; k++) {
            if (k in t && t[k] === searchElement) {
                return k;
            }
        }
        return -1;
    }
}

// NOT NEEDED YET
// [].lastIndexOf
// https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/lastIndexOf
// if (!Array.prototype.lastIndexOf)
// {
//   Array.prototype.lastIndexOf = function(searchElement /*, fromIndex*/)
//   {
//     "use strict";
//
//     if (this === void 0 || this === null)
//       throw new TypeError();
//
//     var t = Object(this);
//     var len = t.length >>> 0;
//     if (len === 0)
//       return -1;
//
//     var n = len;
//     if (arguments.length > 1)
//     {
//       n = Number(arguments[1]);
//       if (n !== n)
//         n = 0;
//       else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0))
//         n = (n > 0 || -1) * Math.floor(Math.abs(n));
//     }
//
//     var k = n >= 0
//           ? Math.min(n, len - 1)
//           : len - Math.abs(n);
//
//     for (; k >= 0; k--)
//     {
//       if (k in t && t[k] === searchElement)
//         return k;
//     }
//     return -1;
//   };
// }


// NOT NEEDED YET
// Array forEach per ECMA standard https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/array/foreach
// Production steps of ECMA-262, Edition 5, 15.4.4.18
// Reference: http://es5.github.com/#x15.4.4.18
// if ( !Array.prototype.forEach ) {
//
//   Array.prototype.forEach = function( callback, thisArg ) {
//
//     var T, k;
//
//     if ( this == null ) {
//       throw new TypeError( " this is null or not defined" );
//     }
//
//     // 1. Let O be the result of calling ToObject passing the |this| value as the argument.
//     var O = Object(this);
//
//     // 2. Let lenValue be the result of calling the Get internal method of O with the argument "length".
//     // 3. Let len be ToUint32(lenValue).
//     var len = O.length >>> 0;
//
//     // 4. If IsCallable(callback) is false, throw a TypeError exception.
//     // See: http://es5.github.com/#x9.11
//     if ( {}.toString.call(callback) != "[object Function]" ) {
//       throw new TypeError( callback + " is not a function" );
//     }
//
//     // 5. If thisArg was supplied, let T be thisArg; else let T be undefined.
//     if ( thisArg ) {
//       T = thisArg;
//     }
//
//     // 6. Let k be 0
//     k = 0;
//
//     // 7. Repeat, while k < len
//     while( k < len ) {
//
//       var kValue;
//
//       // a. Let Pk be ToString(k).
//       //   This is implicit for LHS operands of the in operator
//       // b. Let kPresent be the result of calling the HasProperty internal method of O with argument Pk.
//       //   This step can be combined with c
//       // c. If kPresent is true, then
//       if ( k in O ) {
//
//         // i. Let kValue be the result of calling the Get internal method of O with argument Pk.
//         kValue = O[ Pk ];
//
//         // ii. Call the Call internal method of callback with T as the this value and
//         // argument list containing kValue, k, and O.
//         callback.call( T, kValue, k, O );
//       }
//       // d. Increase k by 1.
//       k++;
//     }
//     // 8. return undefined
//   };
// }


// NOT NEEDED YET
// https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/map
// Production steps of ECMA-262, Edition 5, 15.4.4.19
// Reference: http://es5.github.com/#x15.4.4.19
// if (!Array.prototype.map) {
//   Array.prototype.map = function(callback, thisArg) {
//
//     var T, A, k;
//
//     if (this == null) {
//       throw new TypeError(" this is null or not defined");
//     }
//
//     // 1. Let O be the result of calling ToObject passing the |this| value as the argument.
//     var O = Object(this);
//
//     // 2. Let lenValue be the result of calling the Get internal method of O with the argument "length".
//     // 3. Let len be ToUint32(lenValue).
//     var len = O.length >>> 0;
//
//     // 4. If IsCallable(callback) is false, throw a TypeError exception.
//     // See: http://es5.github.com/#x9.11
//     if ({}.toString.call(callback) != "[object Function]") {
//       throw new TypeError(callback + " is not a function");
//     }
//
//     // 5. If thisArg was supplied, let T be thisArg; else let T be undefined.
//     if (thisArg) {
//       T = thisArg;
//     }
//
//     // 6. Let A be a new array created as if by the expression new Array(len) where Array is
//     // the standard built-in constructor with that name and len is the value of len.
//     A = new Array(len);
//
//     // 7. Let k be 0
//     k = 0;
//
//     // 8. Repeat, while k < len
//     while(k < len) {
//
//       var kValue, mappedValue;
//
//       // a. Let Pk be ToString(k).
//       //   This is implicit for LHS operands of the in operator
//       // b. Let kPresent be the result of calling the HasProperty internal method of O with argument Pk.
//       //   This step can be combined with c
//       // c. If kPresent is true, then
//       if (k in O) {
//
//         // i. Let kValue be the result of calling the Get internal method of O with argument Pk.
//         kValue = O[ k ];
//
//         // ii. Let mappedValue be the result of calling the Call internal method of callback
//         // with T as the this value and argument list containing kValue, k, and O.
//         mappedValue = callback.call(T, kValue, k, O);
//
//         // iii. Call the DefineOwnProperty internal method of A with arguments
//         // Pk, Property Descriptor {Value: mappedValue, Writable: true, Enumerable: true, Configurable: true},
//         // and false.
//
//         // In browsers that support Object.defineProperty, use the following:
//         // Object.defineProperty(A, Pk, { value: mappedValue, writable: true, enumerable: true, configurable: true });
//
//         // For best browser support, use the following:
//         A[ k ] = mappedValue;
//       }
//       // d. Increase k by 1.
//       k++;
//     }
//
//     // 9. return A
//     return A;
//   };
// }
// Event System (J.Resig - Secrets of a JS Ninja http://jsninja.com/ [Go read it, really])
// (Book version isn't completely usable, so fixed some things and borrowed from jQuery where it's working)
//
// This should work very similarly to jQuery's events, however it's based off the book version which isn't as
// robust as jquery's, so there's probably some differences.
//
// When you add an event listener using _V_.addEvent,
//   it stores the handler function in seperate cache object,
//   and adds a generic handler to the element's event,
//   along with a unique id (guid) to the element.

_V_.extend({

  // Add an event listener to element
  // It stores the handler function in a separate cache object
  // and adds a generic handler to the element's event,
  // along with a unique id (guid) to the element.
  addEvent: function(elem, type, fn){
    var data = _V_.getData(elem), handlers;

    // We only need to generate one handler per element
    if (data && !data.handler) {
      // Our new meta-handler that fixes the event object and the context
      data.handler = function(event){
        event = _V_.fixEvent(event);
        var handlers = _V_.getData(elem).events[event.type];
        // Go through and call all the real bound handlers
        if (handlers) {

          // Copy handlers so if handlers are added/removed during the process it doesn't throw everything off.
          var handlersCopy = [];
          _V_.each(handlers, function(handler, i){
            handlersCopy[i] = handler;
          })

          for (var i = 0, l = handlersCopy.length; i < l; i++) {
            handlersCopy[i].call(elem, event);
          }
        }
      };
    }

    // We need a place to store all our event data
    if (!data.events) { data.events = {}; }

    // And a place to store the handlers for this event type
    handlers = data.events[type];

    if (!handlers) {
      handlers = data.events[ type ] = [];

      // Attach our meta-handler to the element, since one doesn't exist
      if (document.addEventListener) {
        elem.addEventListener(type, data.handler, false);
      } else if (document.attachEvent) {
        elem.attachEvent("on" + type, data.handler);
      }
    }

    if (!fn.guid) { fn.guid = _V_.guid++; }

    handlers.push(fn);
  },

  removeEvent: function(elem, type, fn) {
    var data = _V_.getData(elem), handlers;
    // If no events exist, nothing to unbind
    if (!data.events) { return; }

    // Are we removing all bound events?
    if (!type) {
      for (type in data.events) {
        _V_.cleanUpEvents(elem, type);
      }
      return;
    }

    // And a place to store the handlers for this event type
    handlers = data.events[type];

    // If no handlers exist, nothing to unbind
    if (!handlers) { return; }

    // See if we're only removing a single handler
    if (fn && fn.guid) {
      for (var i = 0; i < handlers.length; i++) {
        // We found a match (don't stop here, there could be a couple bound)
        if (handlers[i].guid === fn.guid) {
          // Remove the handler from the array of handlers
          handlers.splice(i--, 1);
        }
      }
    }

    _V_.cleanUpEvents(elem, type);
  },

  cleanUpEvents: function(elem, type) {
    var data = _V_.getData(elem);
    // Remove the events of a particular type if there are none left

    if (data.events[type].length === 0) {
      delete data.events[type];

      // Remove the meta-handler from the element
      if (document.removeEventListener) {
        elem.removeEventListener(type, data.handler, false);
      } else if (document.detachEvent) {
        elem.detachEvent("on" + type, data.handler);
      }
    }

    // Remove the events object if there are no types left
    if (_V_.isEmpty(data.events)) {
      delete data.events;
      delete data.handler;
    }

    // Finally remove the expando if there is no data left
    if (_V_.isEmpty(data)) {
      _V_.removeData(elem);
    }
  },

  fixEvent: function(event) {
    if (event[_V_.expando]) { return event; }
    // store a copy of the original event object
    // and "clone" to set read-only properties
    var originalEvent = event;
    event = new _V_.Event(originalEvent);

    for ( var i = _V_.Event.props.length, prop; i; ) {
      prop = _V_.Event.props[ --i ];
      event[prop] = originalEvent[prop];
    }

    // Fix target property, if necessary
    if (!event.target) { event.target = event.srcElement || document; }

    // check if target is a textnode (safari)
    if (event.target.nodeType === 3) { event.target = event.target.parentNode; }

    // Add relatedTarget, if necessary
    if (!event.relatedTarget && event.fromElement) {
      event.relatedTarget = event.fromElement === event.target ? event.toElement : event.fromElement;
    }

    // Calculate pageX/Y if missing and clientX/Y available
    if ( event.pageX == null && event.clientX != null ) {
      var eventDocument = event.target.ownerDocument || document,
        doc = eventDocument.documentElement,
        body = eventDocument.body;

      event.pageX = event.clientX + (doc && doc.scrollLeft || body && body.scrollLeft || 0) - (doc && doc.clientLeft || body && body.clientLeft || 0);
      event.pageY = event.clientY + (doc && doc.scrollTop  || body && body.scrollTop  || 0) - (doc && doc.clientTop  || body && body.clientTop  || 0);
    }

    // Add which for key events
    if (event.which == null && (event.charCode != null || event.keyCode != null)) {
      event.which = event.charCode != null ? event.charCode : event.keyCode;
    }

    // Add metaKey to non-Mac browsers (use ctrl for PC's and Meta for Macs)
    if ( !event.metaKey && event.ctrlKey ) {
      event.metaKey = event.ctrlKey;
    }

    // Add which for click: 1 === left; 2 === middle; 3 === right
    // Note: button is not normalized, so don't use it
    if ( !event.which && event.button !== undefined ) {
      event.which = (event.button & 1 ? 1 : ( event.button & 2 ? 3 : ( event.button & 4 ? 2 : 0 ) ));
    }

    return event;
  },

  triggerEvent: function(elem, event) {
    var data = _V_.getData(elem),
        parent = elem.parentNode || elem.ownerDocument,
        type = event.type || event,
        handler;

    if (data) { handler = data.handler }

    // Added in attion to book. Book code was broke.
    event = typeof event === "object" ?
      event[_V_.expando] ?
        event :
        new _V_.Event(type, event) :
      new _V_.Event(type);

    event.type = type;
    if (handler) {
      handler.call(elem, event);
    }

    // Clean up the event in case it is being reused
    event.result = undefined;
    event.target = elem;

    // Bubble the event up the tree to the document,
    // Unless it's been explicitly stopped
    // if (parent && !event.isPropagationStopped()) {
    //   _V_.triggerEvent(parent, event);
    //
    // // We're at the top document so trigger the default action
    // } else if (!parent && !event.isDefaultPrevented()) {
    //   // log(type);
    //   var targetData = _V_.getData(event.target);
    //   // log(targetData);
    //   var targetHandler = targetData.handler;
    //   // log("2");
    //   if (event.target[event.type]) {
    //     // Temporarily disable the bound handler,
    //     // don't want to execute it twice
    //     if (targetHandler) {
    //       targetData.handler = function(){};
    //     }
    //
    //     // Trigger the native event (click, focus, blur)
    //     event.target[event.type]();
    //
    //     // Restore the handler
    //     if (targetHandler) {
    //       targetData.handler = targetHandler;
    //     }
    //   }
    // }
  }
});

// Custom Event object for standardizing event objects between browsers.
_V_.Event = function(src, props){
  // Event object
  if (src && src.type) {
    this.originalEvent = src;
    this.type = src.type;

    // Events bubbling up the document may have been marked as prevented
    // by a handler lower down the tree; reflect the correct value.
    this.isDefaultPrevented = (src.defaultPrevented || src.returnValue === false ||
      src.getPreventDefault && src.getPreventDefault()) ? returnTrue : returnFalse;

  // Event type
  } else {
    this.type = src;
  }

  // Put explicitly provided properties onto the event object
  if (props) { _V_.merge(this, props); }

  this.timeStamp = (new Date).getTime();

  // Mark it as fixed
  this[_V_.expando] = true;
};

_V_.Event.prototype = {
  preventDefault: function() {
    this.isDefaultPrevented = returnTrue;

    var e = this.originalEvent;
    if (!e) { return; }

    // if preventDefault exists run it on the original event
    if (e.preventDefault) {
      e.preventDefault();
    // otherwise set the returnValue property of the original event to false (IE)
    } else {
      e.returnValue = false;
    }
  },
  stopPropagation: function() {
    this.isPropagationStopped = returnTrue;

    var e = this.originalEvent;
    if (!e) { return; }
    // if stopPropagation exists run it on the original event
    if (e.stopPropagation) { e.stopPropagation(); }
    // otherwise set the cancelBubble property of the original event to true (IE)
    e.cancelBubble = true;
  },
  stopImmediatePropagation: function() {
    this.isImmediatePropagationStopped = returnTrue;
    this.stopPropagation();
  },
  isDefaultPrevented: returnFalse,
  isPropagationStopped: returnFalse,
  isImmediatePropagationStopped: returnFalse
};
_V_.Event.props = "altKey attrChange attrName bubbles button cancelable charCode clientX clientY ctrlKey currentTarget data detail eventPhase fromElement handler keyCode metaKey newValue offsetX offsetY pageX pageY prevValue relatedNode relatedTarget screenX screenY shiftKey srcElement target toElement view wheelDelta which".split(" ");

function returnTrue(){ return true; }
function returnFalse(){ return false; }

// Javascript JSON implementation
// (Parse Method Only)
// https://github.com/douglascrockford/JSON-js/blob/master/json2.js

var JSON;
if (!JSON) { JSON = {}; }

(function(){
  var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;

  if (typeof JSON.parse !== 'function') {
      JSON.parse = function (text, reviver) {
          var j;

          function walk(holder, key) {
              var k, v, value = holder[key];
              if (value && typeof value === 'object') {
                  for (k in value) {
                      if (Object.prototype.hasOwnProperty.call(value, k)) {
                          v = walk(value, k);
                          if (v !== undefined) {
                              value[k] = v;
                          } else {
                              delete value[k];
                          }
                      }
                  }
              }
              return reviver.call(holder, key, value);
          }
          text = String(text);
          cx.lastIndex = 0;
          if (cx.test(text)) {
              text = text.replace(cx, function (a) {
                  return '\\u' +
                      ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
              });
          }

          if (/^[\],:{}\s]*$/
                  .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                      .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                      .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

              j = eval('(' + text + ')');

              return typeof reviver === 'function' ?
                  walk({'': j}, '') : j;
          }

          throw new SyntaxError('JSON.parse');
      };
  }
}());
/* UI Component- Base class for all UI objects
================================================================================ */
_V_.Player = _V_.Component.extend({

  init: function(tag, addOptions, ready){

    this.tag = tag; // Store the original tag used to set options

    var el = this.el = _V_.createElement("div"), // Div to contain video and controls
        options = this.options = {},
        width = options.width = tag.width,
        height = options.height = tag.height,

        // Browsers default to 300x150 if there's no width/height or video size data.
        initWidth = width || 300,
        initHeight = height || 150;

    // Make player findable on elements
    tag.player = el.player = this;

    // Add callback to ready queue
    this.ready(ready);

    // Wrap video tag in div (el/box) container
    tag.parentNode.insertBefore(el, tag);
    el.appendChild(tag); // Breaks iPhone, fixed in HTML5 setup.

    // Give video tag properties to box
    el.id = this.id = tag.id; // ID will now reference box, not the video tag
    el.className = tag.className;
    // Update tag id/class for use as HTML5 playback tech
    tag.id += "_html5_api";
    tag.className = "vjs-tech";

    // Make player easily findable by ID
    _V_.players[el.id] = this;

    // Make box use width/height of tag, or default 300x150
    el.setAttribute("width", initWidth);
    el.setAttribute("height", initHeight);
    // Enforce with CSS since width/height attrs don't work on divs
    el.style.width = initWidth+"px";
    el.style.height = initHeight+"px";
    // Remove width/height attrs from tag so CSS can make it 100% width/height
    tag.removeAttribute("width");
    tag.removeAttribute("height");

    // Set Options
    _V_.merge(options, _V_.options); // Copy Global Defaults
    _V_.merge(options, this.getVideoTagSettings()); // Override with Video Tag Options
    _V_.merge(options, addOptions); // Override/extend with options from setup call

    // Store controls setting, and then remove immediately so native controls don't flash.
    tag.removeAttribute("controls");

    // Poster will be handled by a manual <img>
    tag.removeAttribute("poster");

    // Empty video tag sources and tracks so the built in player doesn't use them also.
    if (tag.hasChildNodes()) {
      for (var i=0,j=tag.childNodes;i<j.length;i++) {
        if (j[i].nodeName == "SOURCE" || j[i].nodeName == "TRACK") {
          tag.removeChild(j[i]);
        }
      }
    }

    // Holder for playback tech components
    this.techs = {};

    // Cache for video property values.
    this.values = {};

    this.addClass("vjs-paused");

    this.addEvent("ended", this.onEnded);
    this.addEvent("play", this.onPlay);
    this.addEvent("pause", this.onPause);
    this.addEvent("error", this.onError);

    // When the API is ready, loop through the components and add to the player.
    if (options.controls) {
      this.ready(function(){
        this.each(this.options.components, function(set){
          this.addComponent(set);
        });
      });
    }

    // If there are no sources when the player is initialized,
    // load the first supported playback technology.
    if (!options.sources || options.sources.length == 0) {
      for (var i=0,j=options.techOrder; i<j.length; i++) {
        var techName = j[i],
            tech = _V_[techName];

        // Check if the browser supports this technology
        if (tech.isSupported()) {
          this.loadTech(techName);
          break;
        }
      }
    } else {
      // Loop through playback technologies (HTML5, Flash) and check for support
      // Then load the best source.
      this.src(options.sources);
    }
  },

  // Cache for video property values.
  values: {},

  destroy: function(){
    // Ensure that tracking progress and time progress will stop and plater deleted
    this.stopTrackingProgress();
    this.stopTrackingCurrentTime();
    delete _V_.players[this.id]
  },

  createElement: function(type, options){

  },

  getVideoTagSettings: function(){
    var options = {
      sources: [],
      tracks: []
    };

    options.src = this.tag.src;
    options.controls = this.tag.getAttribute("controls") !== null;
    options.poster = this.tag.poster;
    options.preload = this.tag.preload;
    options.autoplay = this.tag.getAttribute("autoplay") !== null; // hasAttribute not IE <8 compatible
    options.loop = this.tag.getAttribute("loop") !== null;
    options.muted = this.tag.getAttribute("muted") !== null;

    for (var c,i=0,j=this.tag.children;i<j.length;i++) {
      c = j[i];
      if (c.nodeName == "SOURCE") {
        options.sources.push({
          src: c.src,
          type: c.type,
          media: c.media,
          title: c.title
        });
      }
      if (c.nodeName == "TRACK") {
        options.tracks.push(new _V_.Track({
          src: c.getAttribute("src"),
          kind: c.getAttribute("kind"),
          srclang: c.getAttribute("srclang"),
          label: c.getAttribute("label"),
          'default': c.getAttribute("default") !== null,
          title: c.getAttribute("title")
        }, this));

      }
    }
    return options;
  },

  /* PLayback Technology (tech)
  ================================================================================ */
  // Load/Create an instance of playback technlogy including element and API methods
  // And append playback element in player div.
  loadTech: function(techName, source){

    // Pause and remove current playback technology
    if (this.tech) {
      this.unloadTech();

    // If the first time loading, HTML5 tag will exist but won't be initialized
    // So we need to remove it if we're not loading HTML5
    } else if (techName != "html5" && this.tag) {
      this.el.removeChild(this.tag);
      this.tag = false;
    }

    this.techName = techName;

    // Turn off API access because we're loading a new tech that might load asynchronously
    this.isReady = false;

    var techReady = function(){
      this.player.triggerReady();

      // Manually track progress in cases where the browser/flash player doesn't report it.
      if (!this.support.progressEvent) {
        this.player.manualProgressOn();
      }

      // Manually track timeudpates in cases where the browser/flash player doesn't report it.
      if (!this.support.timeupdateEvent) {
        this.player.manualTimeUpdatesOn();
      }
    }

    // Grab tech-specific options from player options and add source and parent element to use.
    var techOptions = _V_.merge({ source: source, parentEl: this.el }, this.options[techName])

    if (source) {
      if (source.src == this.values.src && this.values.currentTime > 0) {
        techOptions.startTime = this.values.currentTime;
      }

      this.values.src = source.src;
    }

    // Initialize tech instance
    this.tech = new _V_[techName](this, techOptions);
    this.tech.ready(techReady);
  },

  unloadTech: function(){
    this.tech.destroy();

    // Turn off any manual progress or timeupdate tracking
    if (this.manualProgress) { this.manualProgressOff(); }

    if (this.manualTimeUpdates) { this.manualTimeUpdatesOff(); }

    this.tech = false;
  },

  // There's many issues around changing the size of a Flash (or other plugin) object.
  // First is a plugin reload issue in Firefox that has been around for 11 years: https://bugzilla.mozilla.org/show_bug.cgi?id=90268
  // Then with the new fullscreen API, Mozilla and webkit browsers will reload the flash object after going to fullscreen.
  // To get around this, we're unloading the tech, caching source and currentTime values, and reloading the tech once the plugin is resized.
  reloadTech: function(betweenFn){
    _V_.log("unloadingTech")
    this.unloadTech();
    _V_.log("unloadedTech")
    if (betweenFn) { betweenFn.call(); }
    _V_.log("LoadingTech")
    this.loadTech(this.techName, { src: this.values.src })
    _V_.log("loadedTech")
  },

  /* Fallbacks for unsupported event types
  ================================================================================ */
  // Manually trigger progress events based on changes to the buffered amount
  // Many flash players and older HTML5 browsers don't send progress or progress-like events
  manualProgressOn: function(){
    this.manualProgress = true;

    // Trigger progress watching when a source begins loading
    this.trackProgress();

    // Watch for a native progress event call on the tech element
    // In HTML5, some older versions don't support the progress event
    // So we're assuming they don't, and turning off manual progress if they do.
    this.tech.addEvent("progress", function(){

      // Remove this listener from the element
      this.removeEvent("progress", arguments.callee);

      // Update known progress support for this playback technology
      this.support.progressEvent = true;

      // Turn off manual progress tracking
      this.player.manualProgressOff();
    });
  },

  manualProgressOff: function(){
    this.manualProgress = false;
    this.stopTrackingProgress();
  },

  trackProgress: function(){
    this.progressInterval = setInterval(_V_.proxy(this, function(){
      // Don't trigger unless buffered amount is greater than last time
      // log(this.values.bufferEnd, this.buffered().end(0), this.duration())
      /* TODO: update for multiple buffered regions */
      if (this.values.bufferEnd < this.buffered().end(0)) {
        this.triggerEvent("progress");
      } else if (this.bufferedPercent() == 1) {
        this.stopTrackingProgress();
        this.triggerEvent("progress"); // Last update
      }
    }), 500);
  },
  stopTrackingProgress: function(){ clearInterval(this.progressInterval); },

  /* Time Tracking -------------------------------------------------------------- */
  manualTimeUpdatesOn: function(){
    this.manualTimeUpdates = true;

    this.addEvent("play", this.trackCurrentTime);
    this.addEvent("pause", this.stopTrackingCurrentTime);
    // timeupdate is also called by .currentTime whenever current time is set

    // Watch for native timeupdate event
    this.tech.addEvent("timeupdate", function(){

      // Remove this listener from the element
      this.removeEvent("timeupdate", arguments.callee);

      // Update known progress support for this playback technology
      this.support.timeupdateEvent = true;

      // Turn off manual progress tracking
      this.player.manualTimeUpdatesOff();
    });
  },

  manualTimeUpdatesOff: function(){
    this.manualTimeUpdates = false;
    this.stopTrackingCurrentTime();
    this.removeEvent("play", this.trackCurrentTime);
    this.removeEvent("pause", this.stopTrackingCurrentTime);
  },

  trackCurrentTime: function(){
    if (this.currentTimeInterval) { this.stopTrackingCurrentTime(); }
    this.currentTimeInterval = setInterval(_V_.proxy(this, function(){
      this.triggerEvent("timeupdate");
    }), 250); // 42 = 24 fps // 250 is what Webkit uses // FF uses 15
  },

  // Turn off play progress tracking (when paused or dragging)
  stopTrackingCurrentTime: function(){ clearInterval(this.currentTimeInterval); },

  /* Player event handlers (how the player reacts to certain events)
  ================================================================================ */
  onEnded: function(){
    if (this.options.loop) {
      this.currentTime(0);
      this.play();
    } else {
      this.pause();
      this.currentTime(0);
      this.pause();
    }
  },

  onPlay: function(){
    _V_.removeClass(this.el, "vjs-paused");
    _V_.addClass(this.el, "vjs-playing");
  },

  onPause: function(){
    _V_.removeClass(this.el, "vjs-playing");
    _V_.addClass(this.el, "vjs-paused");
  },

  onError: function(e) {
    _V_.log("Video Error", e);
  },

/* Player API
================================================================================ */

  apiCall: function(method, arg){
    if (this.isReady) {
      return this.tech[method](arg);
    } else {
      _V_.log("The playback technology API is not ready yet. Use player.ready(myFunction)."+" ["+method+"]", arguments.callee.caller.arguments.callee.caller.arguments.callee.caller)
      return false;
      // throw new Error("The playback technology API is not ready yet. Use player.ready(myFunction)."+" ["+method+"]");
    }
  },

  play: function(){
    this.apiCall("play"); return this;
  },
  pause: function(){
    this.apiCall("pause"); return this;
  },
  paused: function(){
    return this.apiCall("paused");
  },

  currentTime: function(seconds){
    if (seconds !== undefined) {

      // Cache the last set value for smoother scrubbing.
      this.values.lastSetCurrentTime = seconds;

      this.apiCall("setCurrentTime", seconds);

      if (this.manualTimeUpdates) {
        this.triggerEvent("timeupdate");
      }
      return this;
    }

    // Cache last currentTime and return
    return this.values.currentTime = this.apiCall("currentTime");
  },
  duration: function(){
    return this.apiCall("duration");
  },
  remainingTime: function(){
    return this.duration() - this.currentTime();
  },

  buffered: function(){
    var buffered = this.apiCall("buffered"),
        start = 0, end = this.values.bufferEnd = this.values.bufferEnd || 0,
        timeRange;

    if (buffered && buffered.length > 0 && buffered.end(0) !== end) {
      end = buffered.end(0);
      // Storing values allows them be overridden by setBufferedFromProgress
      this.values.bufferEnd = end;
    }

    return _V_.createTimeRange(start, end);
  },

  // Calculates amount of buffer is full
  bufferedPercent: function(){
    return (this.duration()) ? this.buffered().end(0) / this.duration() : 0;
  },

  volume: function(percentAsDecimal){
    if (percentAsDecimal !== undefined) {
      var vol = Math.max(0, Math.min(1, parseFloat(percentAsDecimal))); // Force value to between 0 and 1
      this.values.volume = vol;
      this.apiCall("setVolume", vol);
      _V_.setLocalStorage("volume", vol);
      return this;
    }
    // if (this.values.volume) { return this.values.volume; }
    return this.apiCall("volume");
  },
  muted: function(muted){
    if (muted !== undefined) {
      this.apiCall("setMuted", muted);
      return this;
    }
    return this.apiCall("muted");
  },

  width: function(width, skipListeners){
    if (width !== undefined) {
      this.el.width = width;
      this.el.style.width = width+"px";
      if (!skipListeners) { this.triggerEvent("resize"); }
      return this;
    }
    return parseInt(this.el.getAttribute("width"));
  },
  height: function(height){
    if (height !== undefined) {
      this.el.height = height;
      this.el.style.height = height+"px";
      this.triggerEvent("resize");
      return this;
    }
    return parseInt(this.el.getAttribute("height"));
  },
  size: function(width, height){
    // Skip resize listeners on width for optimization
    return this.width(width, true).height(height);
  },

  supportsFullScreen: function(){ return this.apiCall("supportsFullScreen"); },

  // Turn on fullscreen (or window) mode
  requestFullScreen: function(){
    var requestFullScreen = _V_.support.requestFullScreen;

    // Check for browser element fullscreen support
    if (requestFullScreen) {
      // Flash and other plugins get reloaded when you take their parent to fullscreen.
      // To fix that we'll remove the tech, and reload it after the resize has finished.
      if (this.tech.support.fullscreenResize === false) {

        this.pause();
        this.unloadTech();

        _V_.addEvent(document, "keydown", _V_.proxy(this, function(e){
          _V_.log("asdf", e)
        }));

        _V_.addEvent(document, requestFullScreen.eventName, this.proxy(function(){
          _V_.removeEvent(document, requestFullScreen.eventName, arguments.callee);
          this.loadTech(this.techName, { src: this.values.src });
        }));

        this.el[requestFullScreen.requestFn]();

      } else {
        this.el[requestFullScreen.requestFn]();
      }

    } else if (this.tech.supportsFullScreen()) {
      this.apiCall("enterFullScreen");

    } else {
      this.enterFullWindow();
    }

     this.videoIsFullScreen = true;
     this.triggerEvent("fullscreenchange");

     return this;
   },

   cancelFullScreen: function(){
    var requestFullScreen = _V_.support.requestFullScreen;

    // Check for browser element fullscreen support
    if (requestFullScreen) {

     // Flash and other plugins get reloaded when you take their parent to fullscreen.
     // To fix that we'll remove the tech, and reload it after the resize has finished.
     if (this.tech.support.fullscreenResize === false) {

       this.pause();
       this.unloadTech();

       _V_.addEvent(document, requestFullScreen.eventName, this.proxy(function(){
         _V_.removeEvent(document, requestFullScreen.eventName, arguments.callee);
         _V_.log("document fullscreeneventchange")
         this.loadTech(this.techName, { src: this.values.src })
       }));

       document[requestFullScreen.cancelFn]();

     } else {
       document[requestFullScreen.cancelFn]();
     }

    } else if (this.tech.supportsFullScreen()) {
     this.apiCall("exitFullScreen");

    } else {
     this.exitFullWindow();
    }

    this.videoIsFullScreen = false;
    this.triggerEvent("fullscreenchange");

    return this;
  },

  enterFullWindow: function(){
    this.videoIsFullScreen = true;

    // Storing original doc overflow value to return to when fullscreen is off
    this.docOrigOverflow = document.documentElement.style.overflow;

    // Add listener for esc key to exit fullscreen
    _V_.addEvent(document, "keydown", _V_.proxy(this, this.fullWindowOnEscKey));

    // Hide any scroll bars
    document.documentElement.style.overflow = 'hidden';

    // Apply fullscreen styles
    _V_.addClass(document.body, "vjs-full-window");
    _V_.addClass(this.el, "vjs-fullscreen");

    this.triggerEvent("enterFullWindow");
  },

  fullWindowOnEscKey: function(event){
    if (event.keyCode == 27) {
      this.cancelFullScreen();
    }
  },

  exitFullWindow: function(){
    this.videoIsFullScreen = false;
    _V_.removeEvent(document, "keydown", this.fullWindowOnEscKey);

    // Unhide scroll bars.
    document.documentElement.style.overflow = this.docOrigOverflow;

    // Remove fullscreen styles
    _V_.removeClass(document.body, "vjs-full-window");
    _V_.removeClass(this.el, "vjs-fullscreen");

    // Resize the box, controller, and poster to original sizes
    // this.positionAll();
    this.triggerEvent("exitFullWindow");
  },

  // src is a pretty powerful function
  // If you pass it an array of source objects, it will find the best source to play and use that object.src
  //   If the new source requires a new playback technology, it will switch to that.
  // If you pass it an object, it will set the source to object.src
  // If you pass it anything else (url string) it will set the video source to that
  src: function(source){
    // Case: Array of source objects to choose from and pick the best to play
    if (source instanceof Array) {

      var sources = source;

      techLoop: // Named loop for breaking both loops
      // Loop through each playback technology in the options order
      for (var i=0,j=this.options.techOrder;i<j.length;i++) {
        var techName = j[i],
            tech = _V_[techName];
            // tech = _V_.tech[techName];

        // Check if the browser supports this technology
        if (tech.isSupported()) {

          // Loop through each source object
          for (var a=0,b=sources;a<b.length;a++) {
            var source = b[a];

            // Check if source can be played with this technology
            if (tech.canPlaySource.call(this, source)) {

              // If this technology is already loaded, set source
              if (techName == this.currentTechName) {
                this.src(source); // Passing the source object

              // Otherwise load this technology with chosen source
              } else {
                this.loadTech(techName, source);
              }

              break techLoop; // Break both loops
            }
          }
        }
      }

    // Case: Source object { src: "", type: "" ... }
    } else if (source instanceof Object) {
      if (_V_[this.techName].canPlaySource(source)) {
        this.src(source.src);
      } else {
        // Send through tech loop to check for a compatible technology.
        this.src([source]);
      }
    // Case: URL String (http://myvideo...)
    } else {
      // Cache for getting last set source
      this.values.src = source;

      if (!this.isReady) {
        this.ready(function(){
          this.src(source);
        });
      } else {
        this.apiCall("src", source);
        if (this.options.preload == "auto") {
          this.load();
        }
        if (this.options.autoplay) {
          this.play();
        }
      }
    }
    return this;
  },

  // Begin loading the src data
  load: function(){
    this.apiCall("load");
    return this;
  },
  currentSrc: function(){
    return this.apiCall("currentSrc");
  },

  textTrackValue: function(kind, value){
    if (value !== undefined) {
      this.values[kind] = value;
      this.triggerEvent(kind+"update");
      return this;
    }
    return this.values[kind];
  },

  // Attributes/Options
  preload: function(value){
    if (value !== undefined) {
      this.apiCall("setPreload", value);
      this.options.preload = value;
      return this;
    }
    return this.apiCall("preload", value);
  },
  autoplay: function(value){
    if (value !== undefined) {
      this.apiCall("setAutoplay", value);
      this.options.autoplay = value;
      return this;
    }
    return this.apiCall("autoplay", value);
  },
  loop: function(value){
    if (value !== undefined) {
      this.apiCall("setLoop", value);
      this.options.loop = value;
      return this;
    }
    return this.apiCall("loop", value);
  },

  controls: function(){ return this.options.controls; },
  textTracks: function(){ return this.options.tracks; },
  poster: function(){ return this.apiCall("poster"); },

  error: function(){ return this.apiCall("error"); },
  networkState: function(){ return this.apiCall("networkState"); },
  readyState: function(){ return this.apiCall("readyState"); },
  seeking: function(){ return this.apiCall("seeking"); },
  initialTime: function(){ return this.apiCall("initialTime"); },
  startOffsetTime: function(){ return this.apiCall("startOffsetTime"); },
  played: function(){ return this.apiCall("played"); },
  seekable: function(){ return this.apiCall("seekable"); },
  ended: function(){ return this.apiCall("ended"); },
  videoTracks: function(){ return this.apiCall("videoTracks"); },
  audioTracks: function(){ return this.apiCall("audioTracks"); },
  videoWidth: function(){ return this.apiCall("videoWidth"); },
  videoHeight: function(){ return this.apiCall("videoHeight"); },
  defaultPlaybackRate: function(){ return this.apiCall("defaultPlaybackRate"); },
  playbackRate: function(){ return this.apiCall("playbackRate"); },
  // mediaGroup: function(){ return this.apiCall("mediaGroup"); },
  // controller: function(){ return this.apiCall("controller"); },
  controls: function(){ return this.apiCall("controls"); },
  defaultMuted: function(){ return this.apiCall("defaultMuted"); }
});

// RequestFullscreen API
(function(){
  var requestFn,
      cancelFn,
      playerProto = _V_.Player.prototype;

  // Current W3C Spec
  // http://dvcs.w3.org/hg/fullscreen/raw-file/tip/Overview.html#api
  // Mozilla Draft: https://wiki.mozilla.org/Gecko:FullScreenAPI#fullscreenchange_event
  if (document.cancelFullscreen !== undefined) {
    requestFn = "requestFullscreen";
    cancelFn = "exitFullscreen";
    eventName = "fullscreenchange";

  // Webkit (Chrome/Safari) and Mozilla (Firefox) have working implementaitons
  // that use prefixes and vary slightly from the new W3C spec. Specifically, using 'exit' instead of 'cancel',
  // and lowercasing the 'S' in Fullscreen.
  // Other browsers don't have any hints of which version they might follow yet, so not going to try to predict by loopeing through all prefixes.
  } else {

    _V_.each(["moz", "webkit"], function(prefix){

      if (document[prefix + "CancelFullScreen"] !== undefined) {
        requestFn = prefix + "RequestFullScreen";
        cancelFn = prefix + "CancelFullScreen";
        eventName = prefix + "fullscreenchange";
      }

    });

  }

  if (requestFn) {
    _V_.support.requestFullScreen = {
      requestFn: requestFn,
      cancelFn: cancelFn,
      eventName: eventName
    };
  }

})();_V_.addEvent(window, "load", function(){
  _V_.windowLoaded = true;
});
_V_.autoSetupTimeout();/* Playback Technology - Base class for playback technologies
================================================================================ */
_V_.PlaybackTech = _V_.Component.extend({
  init: function(player, options){
    // this._super(player, options);

    // Make playback element clickable
    // _V_.addEvent(this.el, "click", _V_.proxy(this, _V_.PlayToggle.prototype.onClick));

    // this.addEvent("click", this.proxy(this.onClick));

    // player.triggerEvent("techready");
  },
  // destroy: function(){},
  // createElement: function(){},
  onClick: function(){
    if (this.player.options.controls) {
      _V_.PlayToggle.prototype.onClick.call(this);
    }
  }
});

// Create placeholder methods for each that warn when a method isn't supported by the current playback technology
_V_.apiMethods = "play,pause,paused,currentTime,setCurrentTime,duration,buffered,volume,setVolume,muted,setMuted,width,height,supportsFullScreen,enterFullScreen,src,load,currentSrc,preload,setPreload,autoplay,setAutoplay,loop,setLoop,error,networkState,readyState,seeking,initialTime,startOffsetTime,played,seekable,ended,videoTracks,audioTracks,videoWidth,videoHeight,textTracks,defaultPlaybackRate,playbackRate,mediaGroup,controller,controls,defaultMuted".split(",");
_V_.each(_V_.apiMethods, function(methodName){
  _V_.PlaybackTech.prototype[methodName] = function(){
    throw new Error("The '"+method+"' method is not available on the playback technology's API");
  }
});

/* HTML5 Playback Technology - Wrapper for HTML5 Media API
================================================================================ */
_V_.html5 = _V_.PlaybackTech.extend({

  init: function(player, options, ready){
    this.player = player;
    this.el = this.createElement();
    this.ready(ready);

    this.addEvent("click", this.proxy(this.onClick));

    var source = options.source;

    // If the element source is already set, we may have missed the loadstart event, and want to trigger it.
    // We don't want to set the source again and interrupt playback.
    if (source && this.el.currentSrc == source.src) {
      player.triggerEvent("loadstart");

    // Otherwise set the source if one was provided.
    } else if (source) {
      this.el.src = source.src;
    }

    // Chrome and Safari both have issues with autoplay.
    // In Safari (5.1.1), when we move the video element into the container div, autoplay doesn't work.
    // In Chrome (15), if you have autoplay + a poster + no controls, the video gets hidden (but audio plays)
    // This fixes both issues. Need to wait for API, so it updates displays correctly
    player.ready(function(){
      if (this.options.autoplay && this.paused()) {
        this.tag.poster = null; // Chrome Fix. Fixed in Chrome v16.
        this.play();
      }
    });

    this.setupTriggers();

    this.triggerReady();
  },

  destroy: function(){
    this.player.tag = false;
    this.removeTriggers();
    this.el.parentNode.removeChild(this.el);
  },

  createElement: function(){
    var html5 = _V_.html5,
        player = this.player,

        // If possible, reuse original tag for HTML5 playback technology element
        el = player.tag,
        newEl;

    // Check if this browser supports moving the element into the box.
    // On the iPhone video will break if you move the element,
    // So we have to create a brand new element.
    if (!el || this.support.movingElementInDOM === false) {

      // If the original tag is still there, remove it.
      if (el) {
        player.el.removeChild(el);
      }

      newEl = _V_.createElement("video", {
        id: el.id || player.el.id + "_html5_api",
        className: el.className || "vjs-tech"
      });

      el = newEl;
      _V_.insertFirst(el, player.el);
    }

    // Update tag settings, in case they were overridden
    _V_.each(["autoplay","preload","loop","muted"], function(attr){ // ,"poster"
      el[attr] = player.options[attr];
    }, this);

    return el;
  },

  // Make video events trigger player events
  // May seem verbose here, but makes other APIs possible.
  setupTriggers: function(){
    _V_.each.call(this, _V_.html5.events, function(type){
      _V_.addEvent(this.el, type, _V_.proxy(this.player, this.eventHandler));
    });
  },
  removeTriggers: function(){
    _V_.each.call(this, _V_.html5.events, function(type){
      _V_.removeEvent(this.el, type, _V_.proxy(this.player, this.eventHandler));
    });
  },
  eventHandler: function(e){
    e.stopPropagation();
    this.triggerEvent(e);
  },

  play: function(){ this.el.play(); },
  pause: function(){ this.el.pause(); },
  paused: function(){ return this.el.paused; },

  currentTime: function(){ return this.el.currentTime; },
  setCurrentTime: function(seconds){
    try {
      this.el.currentTime = seconds;
      } catch(e) {
        _V_.log(e, "Video isn't ready. (VideoJS)");
      // this.warning(VideoJS.warnings.videoNotReady);
    }
  },

  duration: function(){ return this.el.duration || 0; },
  buffered: function(){ return this.el.buffered; },

  volume: function(){ return this.el.volume; },
  setVolume: function(percentAsDecimal){ this.el.volume = percentAsDecimal; },
  muted: function(){ return this.el.muted; },
  setMuted: function(muted){ this.el.muted = muted },

  width: function(){ return this.el.offsetWidth; },
  height: function(){ return this.el.offsetHeight; },

  supportsFullScreen: function(){
    if (typeof this.el.webkitEnterFullScreen == 'function') {

      // Seems to be broken in Chromium/Chrome && Safari in Leopard
      if (!navigator.userAgent.match("Chrome") && !navigator.userAgent.match("Mac OS X 10.5")) {
        return true;
      }
    }
    return false;
  },

  enterFullScreen: function(){
      try {
        this.el.webkitEnterFullScreen();
      } catch (e) {
        if (e.code == 11) {
          // this.warning(VideoJS.warnings.videoNotReady);
          _V_.log("VideoJS: Video not ready.")
        }
      }
  },
  src: function(src){ this.el.src = src; },
  load: function(){ this.el.load(); },
  currentSrc: function(){ return this.el.currentSrc; },

  preload: function(){ return this.el.preload; },
  setPreload: function(val){ this.el.preload = val; },
  autoplay: function(){ return this.el.autoplay; },
  setAutoplay: function(val){ this.el.autoplay = val; },
  loop: function(){ return this.el.loop; },
  setLoop: function(val){ this.el.loop = val; },

  error: function(){ return this.el.error; },
  networkState: function(){ return this.el.networkState; },
  readyState: function(){ return this.el.readyState; },
  seeking: function(){ return this.el.seeking; },
  initialTime: function(){ return this.el.initialTime; },
  startOffsetTime: function(){ return this.el.startOffsetTime; },
  played: function(){ return this.el.played; },
  seekable: function(){ return this.el.seekable; },
  ended: function(){ return this.el.ended; },
  videoTracks: function(){ return this.el.videoTracks; },
  audioTracks: function(){ return this.el.audioTracks; },
  videoWidth: function(){ return this.el.videoWidth; },
  videoHeight: function(){ return this.el.videoHeight; },
  textTracks: function(){ return this.el.textTracks; },
  defaultPlaybackRate: function(){ return this.el.defaultPlaybackRate; },
  playbackRate: function(){ return this.el.playbackRate; },
  mediaGroup: function(){ return this.el.mediaGroup; },
  controller: function(){ return this.el.controller; },
  controls: function(){ return this.player.options.controls; },
  defaultMuted: function(){ return this.el.defaultMuted; }
});

/* HTML5 Support Testing -------------------------------------------------------- */

_V_.html5.isSupported = function(){
  return !!document.createElement("video").canPlayType;
};

_V_.html5.canPlaySource = function(srcObj){
  return !!document.createElement("video").canPlayType(srcObj.type);
  // TODO: Check Type
  // If no Type, check ext
  // Check Media Type
};

// List of all HTML5 events (various uses).
_V_.html5.events = "loadstart,suspend,abort,error,emptied,stalled,loadedmetadata,loadeddata,canplay,canplaythrough,playing,waiting,seeking,seeked,ended,durationchange,timeupdate,progress,play,pause,ratechange,volumechange".split(",");

/* HTML5 Device Fixes ---------------------------------------------------------- */

_V_.html5.prototype.support = {

  // Support for tech specific full screen. (webkitEnterFullScreen, not requestFullscreen)
  // http://developer.apple.com/library/safari/#documentation/AudioVideo/Reference/HTMLVideoElementClassReference/HTMLVideoElement/HTMLVideoElement.html
  // Seems to be broken in Chromium/Chrome && Safari in Leopard
  fullscreen: (typeof _V_.testVid.webkitEnterFullScreen !== undefined) ? (!_V_.ua.match("Chrome") && !_V_.ua.match("Mac OS X 10.5") ? true : false) : false,

  // In iOS, if you move a video element in the DOM, it breaks video playback.
  movingElementInDOM: !_V_.isIOS()

};

// Android
if (_V_.isAndroid()) {

  // Override Android 2.2 and less canPlayType method which is broken
  if (_V_.androidVersion() < 3) {
    document.createElement("video").constructor.prototype.canPlayType = function(type){
      return (type && type.toLowerCase().indexOf("video/mp4") != -1) ? "maybe" : "";
    };
  }
}


/* VideoJS-SWF - Custom Flash Player with HTML5-ish API
================================================================================ */
_V_.flash = _V_.PlaybackTech.extend({

  init: function(player, options){
    this.player = player;

    var source = options.source,
        parentEl = options.parentEl,
        placeHolder = this.el = _V_.createElement("div", { id: parentEl.id + "_temp_flash" }),
        objId = player.el.id+"_flash_api",
        playerOptions = player.options;

        flashVars = _V_.merge({

          // SWF Callback Functions
          readyFunction: "_V_.flash.onSWFReady",
          eventProxyFunction: "_V_.flash.onSWFEvent",
          errorEventProxyFunction: "_V_.flash.onSWFErrorEvent",

          // Player Settings
          autoplay: playerOptions.autoplay,
          preload: playerOptions.preload,
          loop: playerOptions.loop,
          muted: playerOptions.muted

        }, options.flashVars),

        params = _V_.merge({
          allowScriptAccess: "always",
          wmode: "opaque",
          bgcolor: "#000000"
        }, options.params),

        attributes = _V_.merge({
          id: objId,
          name: objId,
          'class': 'vjs-tech'
        }, options.attributes);


    // EDIT: Trying to just us a manual <img> for poster.
    // if (playerOptions.poster) {
    //   flashVars.poster = playerOptions.poster;
    // }

    // If source was supplied pass as a flash var.
    if (source) {
      flashVars.src = source.src;
    }

    // Add to box.
    _V_.insertFirst(placeHolder, parentEl);

    if (options.startTime) {
      this.ready(function(){
        this.load();
        this.play();
        this.currentTime(options.startTime);
      });
    }

    swfobject.embedSWF(options.swf, placeHolder.id, "480", "270", "9.0.124", "", flashVars, params, attributes);
  },

  destroy: function(){
    this.el.parentNode.removeChild(this.el);
  },

  // setupTriggers: function(){}, // Using global onSWFEvent func to distribute events

  play: function(){ this.el.vjs_play(); },
  pause: function(){ this.el.vjs_pause(); },
  src: function(src){
    this.el.vjs_src(src);

    // Currently the SWF doesn't autoplay if you load a source later.
    // e.g. Load player w/ no source, wait 2s, set src.
    if (this.player.autoplay) {
      var tech = this;
      setTimeout(function(){ tech.play(); }, 0);
    }
  },
  load: function(){ this.el.vjs_load(); },
  poster: function(){ this.el.vjs_getProperty("poster"); },

  buffered: function(){
    return _V_.createTimeRange(0, this.el.vjs_getProperty("buffered"));
  },

  supportsFullScreen: function(){
    return false; // Flash does not allow fullscreen through javascript
  },
  enterFullScreen: function(){
    return false;
  }
});

// Create setters and getters for attributes
(function(){
  var api = _V_.flash.prototype,
      readWrite = "preload,currentTime,defaultPlaybackRate,playbackRate,autoplay,loop,mediaGroup,controller,controls,volume,muted,defaultMuted".split(","),
      readOnly = "error,currentSrc,networkState,readyState,seeking,initialTime,duration,startOffsetTime,paused,played,seekable,ended,videoTracks,audioTracks,videoWidth,videoHeight,textTracks".split(","),
      callOnly = "load,play,pause".split(",");
      // Overridden: buffered

      createSetter = function(attr){
        var attrUpper = attr.charAt(0).toUpperCase() + attr.slice(1);
        api["set"+attrUpper] = function(val){ return this.el.vjs_setProperty(attr, val); };
      },

      createGetter = function(attr){
        api[attr] = function(){ return this.el.vjs_getProperty(attr); };
      };

  // Create getter and setters for all read/write attributes
  _V_.each(readWrite, function(attr){
    createGetter(attr);
    createSetter(attr);
  });

  // Create getters for read-only attributes
  _V_.each(readOnly, function(attr){
    createGetter(attr);
  });
})();

/* Flash Support Testing -------------------------------------------------------- */

_V_.flash.isSupported = function(){
  return swfobject.hasFlashPlayerVersion("10");
};

_V_.flash.canPlaySource = function(srcObj){
  if (srcObj.type in _V_.flash.prototype.support.formats) { return "maybe"; }
};

_V_.flash.prototype.support = {
  formats: {
    "video/flv": "FLV",
    "video/x-flv": "FLV",
    "video/mp4": "MP4",
    "video/m4v": "MP4"
  },

  // Optional events that we can manually mimic with timers
  progressEvent: false,
  timeupdateEvent: false,

  // Resizing plugins using request fullscreen reloads the plugin
  fullscreenResize: false,

  // Resizing plugins in Firefox always reloads the plugin (e.g. full window mode)
  parentResize: !(_V_.ua.match("Firefox"))
};

_V_.flash.onSWFReady = function(currSwf){

  var el = _V_.el(currSwf);

  // Get player from box
  // On firefox reloads, el might already have a player
  var player = el.player || el.parentNode.player,
      tech = player.tech;

  // Reference player on tech element
  el.player = player;

  // Update reference to playback technology element
  tech.el = el;

  // Now that the element is ready, make a click on the swf play the video
  tech.addEvent("click", tech.onClick);

  _V_.flash.checkReady(tech);
};

// The SWF isn't alwasy ready when it says it is. Sometimes the API functions still need to be added to the object.
// If it's not ready, we set a timeout to check again shortly.
_V_.flash.checkReady = function(tech){
  if (tech.el.vjs_getProperty) {
    tech.triggerReady();
  } else {
    setTimeout(function(){
      _V_.flash.checkReady(tech);
    }, 50);
  }
};

_V_.flash.onSWFEvent = function(swfID, eventName, other){
  try {
    var player = _V_.el(swfID).player;
    if (player && player.techName == "flash") {
      player.triggerEvent(eventName);
    }
  } catch(err) {
    _V_.log(err);
  }
};

_V_.flash.onSWFErrorEvent = function(swfID, eventName){
  _V_.log("Flash Error", eventName);
};
_V_.Track = function(attributes, player){
  // Store reference to the parent player
  this.player = player;

  this.src = attributes.src;
  this.kind = attributes.kind;
  this.srclang = attributes.srclang;
  this.label = attributes.label;
  this["default"] = attributes["default"]; // 'default' is reserved-ish
  this.title = attributes.title;

  this.cues = [];
  this.currentCue = false;
  this.lastCueIndex = 0;

  // Update current cue on timeupdate
  player.addEvent("timeupdate", _V_.proxy(this, this.update));

  // Reset cue time on media end
  player.addEvent("ended", _V_.proxy(this, function() { this.lastCueIndex = 0; }));

  // Load Track File
  _V_.get(attributes.src, _V_.proxy(this, this.parseCues));
};

_V_.Track.prototype = {

  parseCues: function(srcContent) {
    var cue, time, text,
        lines = srcContent.split("\n"),
        line = "";

    for (var i=0; i<lines.length; i++) {
      line = _V_.trim(lines[i]); // Trim whitespace and linebreaks
      if (line) { // Loop until a line with content

        // First line - Number
        cue = {
          id: line, // Cue Number
          index: this.cues.length // Position in Array
        };

        // Second line - Time
        line = _V_.trim(lines[++i]);
        time = line.split(" --> ");
        cue.startTime = this.parseCueTime(time[0]);
        cue.endTime = this.parseCueTime(time[1]);

        // Additional lines - Cue Text
        text = [];
        for (var j=i; j<lines.length; j++) { // Loop until a blank line or end of lines
          line = _V_.trim(lines[++i]);
          if (!line) { break; }
          text.push(line);
        }
        cue.text = text.join('<br/>');

        // Add this cue
        this.cues.push(cue);
      }
    }
  },

  parseCueTime: function(timeText) {
    var parts = timeText.split(':'),
        time = 0;
    // hours => seconds
    time += parseFloat(parts[0])*60*60;
    // minutes => seconds
    time += parseFloat(parts[1])*60;
    // get seconds
    var seconds = parts[2].split(/\.|,/); // Either . or ,
    time += parseFloat(seconds[0]);
    // add miliseconds
    ms = parseFloat(seconds[1]);
    if (ms) { time += ms/1000; }
    return time;
  },

  update: function(){
    // Assuming all cues are in order by time, and do not overlap
    if (this.cues && this.cues.length > 0) {
      var time = this.player.currentTime();
      // If current cue should stay showing, don't do anything. Otherwise, find new cue.
      if (!this.currentCue || this.currentCue.startTime >= time || this.currentCue.endTime < time) {
        var newSubIndex = false,
          // Loop in reverse if lastCue is after current time (optimization)
          // Meaning the user is scrubbing in reverse or rewinding
          reverse = (this.cues[this.lastCueIndex].startTime > time),
          // If reverse, step back 1 becase we know it's not the lastCue
          i = this.lastCueIndex - (reverse ? 1 : 0);
        while (true) { // Loop until broken
          if (reverse) { // Looping in reverse
            // Stop if no more, or this cue ends before the current time (no earlier cues should apply)
            if (i < 0 || this.cues[i].endTime < time) { break; }
            // End is greater than time, so if start is less, show this cue
            if (this.cues[i].startTime < time) {
              newSubIndex = i;
              break;
            }
            i--;
          } else { // Looping forward
            // Stop if no more, or this cue starts after time (no later cues should apply)
            if (i >= this.cues.length || this.cues[i].startTime > time) { break; }
            // Start is less than time, so if end is later, show this cue
            if (this.cues[i].endTime > time) {
              newSubIndex = i;
              break;
            }
            i++;
          }
        }

        // Set or clear current cue
        if (newSubIndex !== false) {
          this.currentCue = this.cues[newSubIndex];
          this.lastCueIndex = newSubIndex;
          this.updatePlayer(this.currentCue.text);
        } else if (this.currentCue) {
          this.currentCue = false;
          this.updatePlayer("");
        }
      }
    }
  },

  // Update the stored value for the current track kind
  // and trigger an event to update all text track displays.
  updatePlayer: function(text){
    this.player.textTrackValue(this.kind, text);
  }
};
/*	SWFObject v2.2 <http://code.google.com/p/swfobject/>
	is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
*/
var swfobject=function(){var D="undefined",r="object",S="Shockwave Flash",W="ShockwaveFlash.ShockwaveFlash",q="application/x-shockwave-flash",R="SWFObjectExprInst",x="onreadystatechange",O=window,j=document,t=navigator,T=false,U=[h],o=[],N=[],I=[],l,Q,E,B,J=false,a=false,n,G,m=true,M=function(){var aa=typeof j.getElementById!=D&&typeof j.getElementsByTagName!=D&&typeof j.createElement!=D,ah=t.userAgent.toLowerCase(),Y=t.platform.toLowerCase(),ae=Y?/win/.test(Y):/win/.test(ah),ac=Y?/mac/.test(Y):/mac/.test(ah),af=/webkit/.test(ah)?parseFloat(ah.replace(/^.*webkit\/(\d+(\.\d+)?).*$/,"$1")):false,X=!+"\v1",ag=[0,0,0],ab=null;if(typeof t.plugins!=D&&typeof t.plugins[S]==r){ab=t.plugins[S].description;if(ab&&!(typeof t.mimeTypes!=D&&t.mimeTypes[q]&&!t.mimeTypes[q].enabledPlugin)){T=true;X=false;ab=ab.replace(/^.*\s+(\S+\s+\S+$)/,"$1");ag[0]=parseInt(ab.replace(/^(.*)\..*$/,"$1"),10);ag[1]=parseInt(ab.replace(/^.*\.(.*)\s.*$/,"$1"),10);ag[2]=/[a-zA-Z]/.test(ab)?parseInt(ab.replace(/^.*[a-zA-Z]+(.*)$/,"$1"),10):0}}else{if(typeof O.ActiveXObject!=D){try{var ad=new ActiveXObject(W);if(ad){ab=ad.GetVariable("$version");if(ab){X=true;ab=ab.split(" ")[1].split(",");ag=[parseInt(ab[0],10),parseInt(ab[1],10),parseInt(ab[2],10)]}}}catch(Z){}}}return{w3:aa,pv:ag,wk:af,ie:X,win:ae,mac:ac}}(),k=function(){if(!M.w3){return}if((typeof j.readyState!=D&&j.readyState=="complete")||(typeof j.readyState==D&&(j.getElementsByTagName("body")[0]||j.body))){f()}if(!J){if(typeof j.addEventListener!=D){j.addEventListener("DOMContentLoaded",f,false)}if(M.ie&&M.win){j.attachEvent(x,function(){if(j.readyState=="complete"){j.detachEvent(x,arguments.callee);f()}});if(O==top){(function(){if(J){return}try{j.documentElement.doScroll("left")}catch(X){setTimeout(arguments.callee,0);return}f()})()}}if(M.wk){(function(){if(J){return}if(!/loaded|complete/.test(j.readyState)){setTimeout(arguments.callee,0);return}f()})()}s(f)}}();function f(){if(J){return}try{var Z=j.getElementsByTagName("body")[0].appendChild(C("span"));Z.parentNode.removeChild(Z)}catch(aa){return}J=true;var X=U.length;for(var Y=0;Y<X;Y++){U[Y]()}}function K(X){if(J){X()}else{U[U.length]=X}}function s(Y){if(typeof O.addEventListener!=D){O.addEventListener("load",Y,false)}else{if(typeof j.addEventListener!=D){j.addEventListener("load",Y,false)}else{if(typeof O.attachEvent!=D){i(O,"onload",Y)}else{if(typeof O.onload=="function"){var X=O.onload;O.onload=function(){X();Y()}}else{O.onload=Y}}}}}function h(){if(T){V()}else{H()}}function V(){var X=j.getElementsByTagName("body")[0];var aa=C(r);aa.setAttribute("type",q);var Z=X.appendChild(aa);if(Z){var Y=0;(function(){if(typeof Z.GetVariable!=D){var ab=Z.GetVariable("$version");if(ab){ab=ab.split(" ")[1].split(",");M.pv=[parseInt(ab[0],10),parseInt(ab[1],10),parseInt(ab[2],10)]}}else{if(Y<10){Y++;setTimeout(arguments.callee,10);return}}X.removeChild(aa);Z=null;H()})()}else{H()}}function H(){var ag=o.length;if(ag>0){for(var af=0;af<ag;af++){var Y=o[af].id;var ab=o[af].callbackFn;var aa={success:false,id:Y};if(M.pv[0]>0){var ae=c(Y);if(ae){if(F(o[af].swfVersion)&&!(M.wk&&M.wk<312)){w(Y,true);if(ab){aa.success=true;aa.ref=z(Y);ab(aa)}}else{if(o[af].expressInstall&&A()){var ai={};ai.data=o[af].expressInstall;ai.width=ae.getAttribute("width")||"0";ai.height=ae.getAttribute("height")||"0";if(ae.getAttribute("class")){ai.styleclass=ae.getAttribute("class")}if(ae.getAttribute("align")){ai.align=ae.getAttribute("align")}var ah={};var X=ae.getElementsByTagName("param");var ac=X.length;for(var ad=0;ad<ac;ad++){if(X[ad].getAttribute("name").toLowerCase()!="movie"){ah[X[ad].getAttribute("name")]=X[ad].getAttribute("value")}}P(ai,ah,Y,ab)}else{p(ae);if(ab){ab(aa)}}}}}else{w(Y,true);if(ab){var Z=z(Y);if(Z&&typeof Z.SetVariable!=D){aa.success=true;aa.ref=Z}ab(aa)}}}}}function z(aa){var X=null;var Y=c(aa);if(Y&&Y.nodeName=="OBJECT"){if(typeof Y.SetVariable!=D){X=Y}else{var Z=Y.getElementsByTagName(r)[0];if(Z){X=Z}}}return X}function A(){return !a&&F("6.0.65")&&(M.win||M.mac)&&!(M.wk&&M.wk<312)}function P(aa,ab,X,Z){a=true;E=Z||null;B={success:false,id:X};var ae=c(X);if(ae){if(ae.nodeName=="OBJECT"){l=g(ae);Q=null}else{l=ae;Q=X}aa.id=R;if(typeof aa.width==D||(!/%$/.test(aa.width)&&parseInt(aa.width,10)<310)){aa.width="310"}if(typeof aa.height==D||(!/%$/.test(aa.height)&&parseInt(aa.height,10)<137)){aa.height="137"}j.title=j.title.slice(0,47)+" - Flash Player Installation";var ad=M.ie&&M.win?"ActiveX":"PlugIn",ac="MMredirectURL="+O.location.toString().replace(/&/g,"%26")+"&MMplayerType="+ad+"&MMdoctitle="+j.title;if(typeof ab.flashvars!=D){ab.flashvars+="&"+ac}else{ab.flashvars=ac}if(M.ie&&M.win&&ae.readyState!=4){var Y=C("div");X+="SWFObjectNew";Y.setAttribute("id",X);ae.parentNode.insertBefore(Y,ae);ae.style.display="none";(function(){if(ae.readyState==4){ae.parentNode.removeChild(ae)}else{setTimeout(arguments.callee,10)}})()}u(aa,ab,X)}}function p(Y){if(M.ie&&M.win&&Y.readyState!=4){var X=C("div");Y.parentNode.insertBefore(X,Y);X.parentNode.replaceChild(g(Y),X);Y.style.display="none";(function(){if(Y.readyState==4){Y.parentNode.removeChild(Y)}else{setTimeout(arguments.callee,10)}})()}else{Y.parentNode.replaceChild(g(Y),Y)}}function g(ab){var aa=C("div");if(M.win&&M.ie){aa.innerHTML=ab.innerHTML}else{var Y=ab.getElementsByTagName(r)[0];if(Y){var ad=Y.childNodes;if(ad){var X=ad.length;for(var Z=0;Z<X;Z++){if(!(ad[Z].nodeType==1&&ad[Z].nodeName=="PARAM")&&!(ad[Z].nodeType==8)){aa.appendChild(ad[Z].cloneNode(true))}}}}}return aa}function u(ai,ag,Y){var X,aa=c(Y);if(M.wk&&M.wk<312){return X}if(aa){if(typeof ai.id==D){ai.id=Y}if(M.ie&&M.win){var ah="";for(var ae in ai){if(ai[ae]!=Object.prototype[ae]){if(ae.toLowerCase()=="data"){ag.movie=ai[ae]}else{if(ae.toLowerCase()=="styleclass"){ah+=' class="'+ai[ae]+'"'}else{if(ae.toLowerCase()!="classid"){ah+=" "+ae+'="'+ai[ae]+'"'}}}}}var af="";for(var ad in ag){if(ag[ad]!=Object.prototype[ad]){af+='<param name="'+ad+'" value="'+ag[ad]+'" />'}}aa.outerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'+ah+">"+af+"</object>";N[N.length]=ai.id;X=c(ai.id)}else{var Z=C(r);Z.setAttribute("type",q);for(var ac in ai){if(ai[ac]!=Object.prototype[ac]){if(ac.toLowerCase()=="styleclass"){Z.setAttribute("class",ai[ac])}else{if(ac.toLowerCase()!="classid"){Z.setAttribute(ac,ai[ac])}}}}for(var ab in ag){if(ag[ab]!=Object.prototype[ab]&&ab.toLowerCase()!="movie"){e(Z,ab,ag[ab])}}aa.parentNode.replaceChild(Z,aa);X=Z}}return X}function e(Z,X,Y){var aa=C("param");aa.setAttribute("name",X);aa.setAttribute("value",Y);Z.appendChild(aa)}function y(Y){var X=c(Y);if(X&&X.nodeName=="OBJECT"){if(M.ie&&M.win){X.style.display="none";(function(){if(X.readyState==4){b(Y)}else{setTimeout(arguments.callee,10)}})()}else{X.parentNode.removeChild(X)}}}function b(Z){var Y=c(Z);if(Y){for(var X in Y){if(typeof Y[X]=="function"){Y[X]=null}}Y.parentNode.removeChild(Y)}}function c(Z){var X=null;try{X=j.getElementById(Z)}catch(Y){}return X}function C(X){return j.createElement(X)}function i(Z,X,Y){Z.attachEvent(X,Y);I[I.length]=[Z,X,Y]}function F(Z){var Y=M.pv,X=Z.split(".");X[0]=parseInt(X[0],10);X[1]=parseInt(X[1],10)||0;X[2]=parseInt(X[2],10)||0;return(Y[0]>X[0]||(Y[0]==X[0]&&Y[1]>X[1])||(Y[0]==X[0]&&Y[1]==X[1]&&Y[2]>=X[2]))?true:false}function v(ac,Y,ad,ab){if(M.ie&&M.mac){return}var aa=j.getElementsByTagName("head")[0];if(!aa){return}var X=(ad&&typeof ad=="string")?ad:"screen";if(ab){n=null;G=null}if(!n||G!=X){var Z=C("style");Z.setAttribute("type","text/css");Z.setAttribute("media",X);n=aa.appendChild(Z);if(M.ie&&M.win&&typeof j.styleSheets!=D&&j.styleSheets.length>0){n=j.styleSheets[j.styleSheets.length-1]}G=X}if(M.ie&&M.win){if(n&&typeof n.addRule==r){n.addRule(ac,Y)}}else{if(n&&typeof j.createTextNode!=D){n.appendChild(j.createTextNode(ac+" {"+Y+"}"))}}}function w(Z,X){if(!m){return}var Y=X?"visible":"hidden";if(J&&c(Z)){c(Z).style.visibility=Y}else{v("#"+Z,"visibility:"+Y)}}function L(Y){var Z=/[\\\"<>\.;]/;var X=Z.exec(Y)!=null;return X&&typeof encodeURIComponent!=D?encodeURIComponent(Y):Y}var d=function(){if(M.ie&&M.win){window.attachEvent("onunload",function(){var ac=I.length;for(var ab=0;ab<ac;ab++){I[ab][0].detachEvent(I[ab][1],I[ab][2])}var Z=N.length;for(var aa=0;aa<Z;aa++){y(N[aa])}for(var Y in M){M[Y]=null}M=null;for(var X in swfobject){swfobject[X]=null}swfobject=null})}}();return{registerObject:function(ab,X,aa,Z){if(M.w3&&ab&&X){var Y={};Y.id=ab;Y.swfVersion=X;Y.expressInstall=aa;Y.callbackFn=Z;o[o.length]=Y;w(ab,false)}else{if(Z){Z({success:false,id:ab})}}},getObjectById:function(X){if(M.w3){return z(X)}},embedSWF:function(ab,ah,ae,ag,Y,aa,Z,ad,af,ac){var X={success:false,id:ah};if(M.w3&&!(M.wk&&M.wk<312)&&ab&&ah&&ae&&ag&&Y){w(ah,false);K(function(){ae+="";ag+="";var aj={};if(af&&typeof af===r){for(var al in af){aj[al]=af[al]}}aj.data=ab;aj.width=ae;aj.height=ag;var am={};if(ad&&typeof ad===r){for(var ak in ad){am[ak]=ad[ak]}}if(Z&&typeof Z===r){for(var ai in Z){if(typeof am.flashvars!=D){am.flashvars+="&"+ai+"="+Z[ai]}else{am.flashvars=ai+"="+Z[ai]}}}if(F(Y)){var an=u(aj,am,ah);if(aj.id==ah){w(ah,true)}X.success=true;X.ref=an}else{if(aa&&A()){aj.data=aa;P(aj,am,ah,ac);return}else{w(ah,true)}}if(ac){ac(X)}})}else{if(ac){ac(X)}}},switchOffAutoHideShow:function(){m=false},ua:M,getFlashPlayerVersion:function(){return{major:M.pv[0],minor:M.pv[1],release:M.pv[2]}},hasFlashPlayerVersion:F,createSWF:function(Z,Y,X){if(M.w3){return u(Z,Y,X)}else{return undefined}},showExpressInstall:function(Z,aa,X,Y){if(M.w3&&A()){P(Z,aa,X,Y)}},removeSWF:function(X){if(M.w3){y(X)}},createCSS:function(aa,Z,Y,X){if(M.w3){v(aa,Z,Y,X)}},addDomLoadEvent:K,addLoadEvent:s,getQueryParamValue:function(aa){var Z=j.location.search||j.location.hash;if(Z){if(/\?/.test(Z)){Z=Z.split("?")[1]}if(aa==null){return L(Z)}var Y=Z.split("&");for(var X=0;X<Y.length;X++){if(Y[X].substring(0,Y[X].indexOf("="))==aa){return L(Y[X].substring((Y[X].indexOf("=")+1)))}}}return""},expressInstallCallback:function(){if(a){var X=c(R);if(X&&l){X.parentNode.replaceChild(l,X);if(Q){w(Q,true);if(M.ie&&M.win){l.style.display="block"}}if(E){E(B)}}a=false}}}}();
// Expose to global
window.VideoJS = window._V_ = VideoJS;

// Run Auto-load players
_V_.autoSetup();

// End self-executing function
})(window);
