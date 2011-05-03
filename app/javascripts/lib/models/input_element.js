

var InputElement = Backbone.Model.extend({
  initialize:function() {
    _.bindAll(this, 'markDirty', 'update_min_value', 'update_max_value', 'update_start_value');
    this.dirty = false;
    this.ui_options = {'element' : $('#input_element_'+this.get('id'))};
    this.bind('change:user_value', this.markDirty);

    if (this.get('min_value_gql') != null && this.get('min_value_gql').length > 1) {
      this.min_value_gquery = new Gquery({key : this.get('min_value_gql')});
      this.min_value_gquery.bind('change', this.update_min_value);
    }
    if (this.get('start_value_gql') != null && this.get('start_value_gql').length > 1) {
      this.start_value_gquery = new Gquery({key : this.get('start_value_gql')});
      this.start_value_gquery.bind('change', this.update_start_value);
    }
    if (this.get('max_value_gql') != null && this.get('max_value_gql').length > 1) {
      this.max_value_gquery = new Gquery({key : this.get('max_value_gql')});
      this.max_value_gquery.bind('change', this.update_max_value);
    }
  },

  // after update_min_max_start_values we no longer need the xxx_value_gquery, 
  // removed it from Gqueries, so that it doesnt calculate everytime.
  update_min_value : function() {
    var factor = this.get('factor');    
    this.set({'min_value' : factor * this.min_value_gquery.get('present_value')});
    window.gqueries.remove(this.min_value_gquery);
  },
  update_max_value : function() {
    var factor = this.get('factor');
    this.set({'max_value' : factor * this.max_value_gquery.get('present_value')});
    window.gqueries.remove(this.max_value_gquery);
  },
  update_start_value : function() {
    var factor = this.get('factor');
    var result = this.start_value_gquery.get('present_value');
    var step_value = this.get('step_value');

    var rounded_result = Metric.round_number(result, this.get('number_to_round_with'));
    result = (rounded_result * factor);

    if (step_value == 0.1 || step_value == 5) 
      result = Metric.round_number(result, 1);

    this.set({'start_value' : result});
    window.gqueries.remove(this.start_value_gquery);
  },

  init_legacy_controller : function() {
    if (this.already_init != true) {
      App.inputElementsController.addInputElement(this);
      this.already_init = true;
    }
  },

  /**
   * Returns if this is dirty, meaning a attribute has changed.
   */
  isDirty:function() {
    return this.dirty;
  },

  markDirty:function() {
    this.dirty = true;
  },

  setDirty:function(dirty) {
    this.dirty = dirty;
  },
});







var InputElementList = Backbone.Collection.extend({
  model : InputElement,

  initialize : function() {
    this.inputElements = {};
    this.inputElementViews = {};
    this.shareGroups = {};
    this.openInputElementInfoBox;    
  },

  init_legacy_controller : function() {
    this.each(function(input_element) {
      input_element.init_legacy_controller();
    });
  },

  /**
   * Get the string which contains the update values for all dirty input elements.
   */  
  api_update_params:function() {
    return this.dirty().map(function(el) {
      return ("input["+el.id+"]=" + el.get("user_value"));      
    }).join("&");
  },

  dirty : function() {
    return this.select(function(el) { return el.isDirty(); });
  },

  reset_dirty : function() {
    _.each(this.dirty(), function(el) { el.setDirty(false); })
  },

  /**
   * Add a constraint to the constraints.
   * @param options - must contain an element item
   */
  addInputElement:function(inputElement, options) {
    var options = inputElement.ui_options;
    this.inputElements[inputElement.id] = inputElement;
    var inputElementView = new InputElementView(inputElement, options.element);
    inputElementView.bind('show', $.proxy(this.handleInputElementInfoBoxShowed, this));
    this.inputElementViews[inputElement.id] = inputElementView;
    inputElementView.sliderView.addEventListener("change", $.proxy(this.handleUpdate, this));
    this.initShareGroup(inputElement);
  },
  
  handleInputElementInfoBoxShowed:function(inputElementView) {
    var infoBox = inputElementView.sliderView.getInfoBox();
    if(this.openInputElementInfoBox && this.openInputElementInfoBox != infoBox)
      this.openInputElementInfoBox.hide();
    
    this.openInputElementInfoBox = infoBox;
  },
  
  
  /**
   * Initialize a share group for an input element if it has one.
   */
  initShareGroup:function(inputElement) {
    var inputElementView = this.inputElementViews[inputElement.id];
    var shareGroupKey = inputElement.get("share_group");
    if(shareGroupKey && shareGroupKey.length) {
      var shareGroup = this.getOrCreateShareGroup(shareGroupKey);
      shareGroup.addEventListener("slider_updated",$.proxy(function(){ inputElement.markDirty();},this)); //set all sliders from same sharegroup to dirty when one is touched
      shareGroup.addSlider(inputElementView.sliderView.sliderVO);
    }
  },

  /**
   * Finds or creates the share group.
   */
  getOrCreateShareGroup:function(shareGroup) {

    if(!this.shareGroups[shareGroup]) 
      this.shareGroups[shareGroup] = new SliderGroup({'total_value':100}); // add group if not created yet
    
    return this.shareGroups[shareGroup];
  },

  /**
   * Does a update request to update the values.
   */  
  handleUpdate:function() {
    this.trigger("change");
  }
});
window.input_elements = new InputElementList();


