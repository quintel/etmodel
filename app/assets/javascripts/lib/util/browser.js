var Browser = {
  doesTouch:function() {
       try {
           // if we can make touch events return true
           document.createEvent("TouchEvent");
           return true;
       } catch(e) {

           return false;
       }
   },

  // Only IE8 needs this
  makeSureArrayHasFunctionIndexOf:function() {
    if (!Array.indexOf) {
      Array.prototype.indexOf = function (obj, start) {
        for (var i = (start || 0); i < this.length; i++) {
          if (this[i] == obj) {
            return i;
          }
        }
        return -1;
      }
    }
  },

  hasProperCORSSupport: function() {
    var ua = $.browser;
    // At the moment we have some issues with FF
    if (ua.webkit || ua.mozilla) { return true; }
    return false;
  },

  hasProperPushStateSupport: function() {
    var ua = $.browser;
    if (ua.webkit) { return true; }
  },

  hasD3Support: function() {
    var ua = $.browser;
    if (ua.msie && ua.version < 9)
      return false;
    else
      return true;
  }
}

Browser.makeSureArrayHasFunctionIndexOf();
