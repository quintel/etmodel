//= require 'mvc/event_dispatcher'
/**
 * Model is the superclass for all models. It's a subclass of EventDispatcher so
 * it can dispatch events. It's kind of the same model as ActiveRecord::Base.
 * 
 * @event "update"  This event is fired when a attribute, or a collection of attributes is
 *                  changed
 *
 */
var View = EventDispatcher.extend({


  /**
   * The initialization of a view. 
   * 
   * @param model(Model)        A model that this view is controlling.
   * @param element(DOMElement) The DOM Element this view will control.
   */
  init:function(model, element) {
    this.model = model;
    this.element = element;
    this.model.addEventListener("update", jQuery.proxy(this.updateHandler, this));
  },
  
  /** 
   * Override this method if you want to customize updating of the view.
   */
  updateHandler:function() {
    
  }
  
  
  
})