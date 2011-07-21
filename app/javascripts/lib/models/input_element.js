

var InputElement = Backbone.Model.extend({
  initialize:function() {
    _.bindAll(this, 'markDirty', 'update_min_value', 'update_max_value', 'update_start_value');
    this.dirty = false;
    this.ui_options = {'element' : $('#input_element_'+this.get('id'))};
    this.bind('change:user_value', this.markDirty);
  },

  set_min_value : function(result) {
    var factor = this.get('factor');    
    this.set({'min_value' : result});
  },
  set_max_value : function(result) {
    var factor = this.get('factor');
    this.set({'max_value' : result});
  },
  set_label : function(label) {
    if(!_.isString(label)) return;
    this.set({'label' : label});
  },
  set_start_value : function(result) {
    var factor = this.get('factor');
    var step_value = this.get('step_value');

    var rounded_result = Metric.round_number(result, this.get('number_to_round_with'));
    result = (rounded_result);

    if (step_value == 0.1 || step_value == 5) 
      result = Metric.round_number(result, 1);

    this.set({'start_value' : result});
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
    if (this.get('input_element_type') == 'fixed') {
      return false;
    } else {
      return this.dirty;
    }
  },

  markDirty:function() {
    this.dirty = true;
  },

  setDirty:function(dirty) {
    this.dirty = dirty;
  }
});


var InputElementList = Backbone.Collection.extend({
  model : InputElement,

  initialize : function() {
    this.inputElements     = {};
    this.inputElementViews = {};

    this.shareGroups = {};
    this.balancers   = {};

    this.openInputElementInfoBox;
  },

  init_legacy_controller : function() {
    this.each(function(input_element) {
      input_element.init_legacy_controller();
    });
  },

  load_user_values : function() {
    _.bindAll(this, 'initialize_user_values');
    $.jsonp({
      url: App.scenario.user_values_url(),
      success : this.initialize_user_values,
      timeout: 15000
    });
  },

  initialize_user_values : function(user_value_hash) {
    this.each(function(input_element) {
      var values = user_value_hash[
        (input_element.get('input_id') || input_element.id) + ''];

      input_element.set_min_value(values.min_value);
      input_element.set_max_value(values.max_value);
      input_element.set_start_value(values.start_value);
      input_element.set_label(values.full_label); 
      var user_value = values.user_value;
      var default_value = (_.isUndefined(user_value) || _.isNaN(user_value) || _.isNull(user_value)) ? values.start_value : user_value;
      input_element.set({user_value : default_value}, {silent : true});

      input_element.init_legacy_controller();
    });
  },

  /**
   * Get the string which contains the update values for all dirty input elements.
   */  
  api_update_params:function() {
    return _.map(this.dirty(), function(el) {
      return ("input["+el.get('input_id')+"]=" + el.get("user_value"));
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
    var inputElementView = new InputElementView({model : inputElement, el : options.element});
    // The following binding was for obscure reasons preventing the videos
    // to work. Commented it out. Investigate. PZ Fri 3 Jun 2011 16:34:36 CEST
    // inputElementView.bind('show', $.proxy(this.handleInputElementInfoBoxShowed, this));
    
    this.inputElementViews[inputElement.id] = inputElementView;
    inputElementView.bind("change", $.proxy(this.handleUpdate, this));

    return true;
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
      shareGroup.bind("slider_updated",$.proxy(function(){ inputElement.markDirty();},this)); //set all sliders from same sharegroup to dirty when one is touched
      shareGroup.addSlider(inputElementView.sliderView.sliderVO);

      var balancer = this.getOrCreateBalancer(shareGroupKey);
      balancer.add(inputElementView);
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

  getOrCreateBalancer: function(name) {
    if (! this.balancers.hasOwnProperty(name)) {
      this.balancers[name] = new InputElementGroup({ max: 100 });
    }

    return this.balancers[name];
  },

  /**
   * Does a update request to update the values.
   */  
  handleUpdate:function() {
    this.trigger("change");
  }
});
window.input_elements = new InputElementList();


