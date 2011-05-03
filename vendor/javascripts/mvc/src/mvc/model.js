//= require 'mvc/event_dispatcher'

/**
 * Model is the superclass for all models. It's a subclass of EventDispatcher so
 * it can dispatch events. It's kind of the same model as ActiveRecord::Base.
 * 
 * @event "update"  This event is fired when a attribute, or a collection of attributes is
 *                  changed
 *
 */
var Model = EventDispatcher.extend({
  
  /**
   * Here a model is initialized, so always call the super method in a subclassed
   * class.
   * @params attributes The attributes that belong to the model.
   */
  init:function(attributes) {
    this.id = attributes.id;
    this.attributes = attributes;
    this.dirty = false;
  },
  
  /**
   * Sets the attribute of a method. Dispatches an event.
   * @event "update"
   * @param key     The key of the attribute
   * @param value   The value that will be set.
   */
  setAttribute:function(key, value, options) {

    var oldValue = this.attributes[key];
    if(oldValue != value) {
      this.attributes[key] = value;
      this.setDirty(true);
      if(!(options && options.noEvent))
        this.dispatchEvent("update");  
    }    
  },
  
  
  /**
   * Gets the attribute.
   * @param key     The key of the attribute
   */
  getAttribute:function(key) {
    return this.attributes[key];
  },
  
  /**
   * Update a hash of attributes. Dispatches an "update" event.
   * @event "update" 
   * @param attributes   Hash of attributes that will be set.
   */
  updateAttributes:function(attributes) {
    for(var key in attributes) {
      this.attributes[key] = attributes[key];
    }
    this.dispatchEvent("update");
  },
  
  /**
   * Returns if this is dirty, meaning a attribute has changed.
   */
  isDirty:function() {
    return this.dirty;
  },

  /**
   * Returns if this is dirty, meaning a attribute has changed.
   */
  setDirty:function(dirty) {
    this.dirty = dirty;
  }



  
  
  

  
});