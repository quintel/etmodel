

var InputElement = Backbone.Model.extend({
  initialize:function() {
    _.bindAll(this, 'markDirty');
    this.dirty = false;
    this.ui_options = {'element' : $('#input_element_'+this.get('id'))};
    this.bind('change:user_value', this.markDirty);
    this.bind('change:user_value', this.logUpdate);
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
    this.set({'start_value' : result});
  },

  init_legacy_controller : function() {
    if (this.already_init != true) {
      App.input_elements.addInputElement(this);
      this.already_init = true;
    }
  },

  logUpdate : function() {
    App.etm_debug('Moved slider: #' + this.get('id') + ' - ' + this.get('key'));
    Tracker.track({
      slider: this.get('translated_name'),
      new_value: this.get('user_value')
    });
  },

  /**
   * Returns if this is dirty, meaning a attribute has changed.
   */
  isDirty:function() {
    if (this.get('fixed') == true) {
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
    $.ajax({
      url: App.scenario.user_values_url(),
      success : this.initialize_user_values,
      timeout: 15000
    });
  },

  initialize_user_values : function(user_value_hash) {
    this.each(function(input_element) {
      var values = user_value_hash['' + input_element.get('input_id')];
      if (!values) {
        console.warn("Missing slider information! " + input_element.get('key') +
          " #" + input_element.get('id'));
        return false;
      }
      input_element.set_min_value(values.min_value);
      input_element.set_max_value(values.max_value);
      input_element.set_start_value(values.start_value);
      input_element.set_label(values.full_label);

      var user_value = values.user_value;
      var default_value = (_.isUndefined(user_value) || _.isNaN(user_value) || _.isNull(user_value)) ? values.start_value : user_value;
      input_element.set({user_value : default_value}, {silent : true});

      // Disable if ET-Model *or* ET-Engine disable the input.
      input_element.set({
        disabled: input_element.get('disabled') || values.disabled
      });

      input_element.init_legacy_controller();
    });
    // UGLY: merit_order is enabled with the settings checkbox, that will trigger an API
    // request setting an input with id of 900. This will update the js settings object,
    // that will update the Current.setting ruby object.
    try {
      var merit_order_enabled = (user_value_hash[900].user_value == 1);
      App.settings.set({'use_merit_order' : merit_order_enabled});
    } catch(e) {
      console.log("Missing Merit order input");
    }
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
    _.each(this.dirty(), function(el) { el.setDirty(false); });
  },

  /**
   * Add a constraint to the constraints.
   * @param options - must contain an element item
   */
  addInputElement:function(inputElement, options) {
    var options = inputElement.ui_options;
    this.inputElements[inputElement.id] = inputElement;
    var inputElementView = new InputElementView({model : inputElement, el : options.element});
    
    this.inputElementViews[inputElement.id] = inputElementView;
    inputElementView.bind("change", $.proxy(this.handleUpdate, this));

    return true;
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


