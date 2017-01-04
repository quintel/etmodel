var Util = {
  /*
   * This function invokes a function after a timeout. If in the mean time this is invoked
   * with other functions, the last functions will be invoked
   */
  cancelableAction: function(key, func, options) {
    var sleepTime = options.sleepTime || 2000;
    if(!this.timeOuts) {
      this.timeOuts = {};
    } else if(this.timeOuts[key]) {
      clearTimeout(this.timeOuts[key]);
    }

    this.timeOuts[key] = setTimeout($.proxy(function() {
      func.apply();
      clearTimeout(this.timeOuts[key]);
    }, this), sleepTime);
  },

  /**
   * Creates a console if no console exists.
   */
  makeSureConsoleExists:function() {
    if (!window.console) console = {};
    console.log = console.log || function(){};
    console.warn = console.warn || function(){};
    console.error = console.error || function(){};
    console.info = console.info || function(){};
  },

  timestamp:function() {
    return (new Date()).getTime();
  }
}

Util.makeSureConsoleExists();

_.extend(_, {
  sum: function(arr) {
    return _.reduce(arr,
                    function(sum, v) {return sum + v;},
                    0);
  }
});
