/**
 * EventDispatcher is a class that implements the subscriber pattern. This
 * class has a method +dispatchEvent(type)+ that can dispatch an event.
 * 
 * Other classes can subscribe to these events by doing .addEventListener().
 * 
 * Note: to preserve the +this+ or current scope. Use jQuery.proxy.
 *
 * @see jQuery.proxy
 * @responsible Jaap van der Meer
 */
var EventDispatcher = Class.extend({

  /**
   * Subscribes to an event. If this event is fired, func is called. See note
   * about jQuery.proxy to proxy the current scope.
   * 
   * @param [event] The event type.
   * @param [func] The function that will be fired.
   */
	addEventListener:function(event, func){
    if(!this.eventListeners)
      this.eventListeners = {};

    if(!this.eventListeners[event]){
      this.eventListeners[event] = [];
    }
    this.eventListeners[event].push(func);
    return this;
  },

  /**
   * Removes listening to a specific function.
   * 
   * @param [event] The event type.
   * @param [func] The function that was listening.
   */
  removeEventListener: function(event, func){
    if(!this.eventListeners[event])
      return;
    for(var i = 0, len = this.eventListeners[event].length; i < len; i+=1){
      if (this.eventListeners[event][i] == func) {
        this.eventListeners[event].splice(i, 1);
      }
    }
    return this;
  },
  
  /**
   * Dispatches an event. Event is just a string.
   * @param [event] The event type.
   */
  dispatchEvent:function(event) {
    var args = [];
    for(var i = 1, len = arguments.length; i < len; i+=1){
      args.push(arguments[i]);
    }

    if(this.eventListeners && this.eventListeners[event]) {
      for(var j = 0, len = this.eventListeners[event].length; j < len; j+=1){
        this.eventListeners[event][j].apply(this, args);
      }
    }
    return this;
  }
});
