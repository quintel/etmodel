//loading overlay vars:
var loading = $("#content").busyBox({spinner: '<img src="/images/layout/ajax-loader.gif" />'} );

_.extend(_, {
  sum: function (arr) {
    return _.reduce(arr, function(sum, v) {return sum + v;}, 0);
  },
  isPresent : function(obj) {
    return !(_.isNull(obj) || _.isUndefined(obj));
  }
});

window.AppView = Backbone.View.extend({
  API_URL : globals.api_url,

  initialize : function() {
    _.bindAll(this, 'api_result', 'handleInputElementsUpdate');

    // this at the moment used for the loading box. to figure out 
    // if there are still api calls happening.
    this.api_call_stack = [];

    // Jaap MVC legacy
    this.inputElementsController = window.input_elements;
    this.inputElementsController.bind("change", this.handleInputElementsUpdate);

    this.municipalityController = new MunicipalityController();

    this.settings = new Setting(); // At this point settings is empty!!
    // let's get the ruby-fetched api_session_key
    this.settings.set({'api_session_key' : globals.api_session_key});
    this.scenario = new Scenario();
    this.peak_load = null; // initialize later in bootstrap, because we need to know what country it is
  },

  // At this point we have all the settings initialized.
  bootstrap : function() {
    if (this.settings.get('country') == 'nl') {
      this.peak_load = new PeakLoad();
    }
    if (this.scenario.api_session_key() == null) {
      this.scenario.new_session();
      // after copmleting new_session() App.bootstrap is called again and will thus continue the else part
    } else {
      this.load_user_values();
      this.call_api();
    }
  },

  // Load User values for Sliders
  load_user_values : function() {
    this.inputElementsController.load_user_values();
  },

  call_api : function(input_params) {
    var self = this;
    var url = this.scenario.query_url(input_params);
    var params = {'r' : window.gqueries.keys() };

    LockableFunction.setLock('call_api');
    this.showLoading();
    var jsonp = $.jsonp({
      url: url,
      data: params,
      success: this.handle_api_result,
      error: function() {
        console.log("Something went wrong"); 
        self.hideLoading();
      }
    });
    this.register_api_call(jsonp);
  },

  has_unfinished_api_calls : function() {
    return _.isEmpty(this.api_call_stack);
  },

  register_api_call : function(api_call) {
    this.api_call_stack.push(api_call);
  },

  unregister_api_call : function(api_call) {
    this.api_call_stack = _.without(this.api_call_stack, api_call);
  },

  // The following method could need some refactoring
  // e.g. el.set({ api_result : value_arr })
  // window.charts.first().trigger('change');
  // window.dashboard.trigger('change');
  handle_api_result : function(data) {
    //#############################################
    // 
    // ATTENTION: This method is not called in the context of App
    //            but in the context of the jsonp object. So 'this'
    //            refers to the jsonp (that's how we get access to data)
    //            and not the App object. 
    // 
    //#############################################
    App.unregister_api_call(this);

    LockableFunction.removeLock('call_api');
    loading.fadeIn('fast'); //show loading overlay
    var result   = data.result;   // Results of this request for every "result[]" parameter

    $.each(result, function(gquery_key, value_arr) { 
      $.each(window.gqueries.with_key(gquery_key), function(i, gquery) {
        gquery.handle_api_result(value_arr);
      });
    });
    window.charts.each(function(chart) { chart.trigger('change'); });
    window.policy_goals.invoke('update_view');
    window.policy_goals.update_totals();

    if (App.peak_load != null) { 
      App.peak_load.trigger('change'); 
    }

    $("body").trigger("dashboardUpdate");
    App.hideLoading();
  },



  /**
   * Set the update in a cancelable action. When you 
   * pull a slider A this method is called. It will call doUpdateRequest
   * after 500ms. When a slider is pulled again, that call will be canceled
   * (so that we don't flood the server). doUpdateRequest will get the dirty
   * sliders, reset all dirtyiness and make an API call. 
   */
  handleInputElementsUpdate:function() {
    var func = $.proxy(this.doUpdateRequest, this);
    var lockable_function = function() { LockableFunction.deferExecutionIfLocked('update', func); };
    Util.cancelableAction('update',  lockable_function, {'sleepTime': 100});
  },
  
  
  /**
   * Get the value of all changed sliders. Get the chart. Sends those values to the server.
   */
  doUpdateRequest:function() {
    var dirtyInputElements = window.input_elements.dirty();

    if (dirtyInputElements.length == 0) { return; }

    var input_params = window.input_elements.api_update_params();
    window.input_elements.reset_dirty();
    window.App.call_api(input_params);
  },


  /*
   * Shows a busy box. Only if api_call_stack is empty. Make sure
   * that you call the showLoading before adding the jsonp to api_call_stack.
   */
  showLoading : function () {
    if (this.has_unfinished_api_calls()) {
      $("#charts_wrapper").busyBox({
        spinner: '<img src="/images/layout/ajax-loader.gif" />'
      }).fadeIn('fast') 
      $("#constraints").busyBox({
        classes: 'busybox ontop',
        spinner: '<img src="/images/layout/ajax-loader.gif" />'
      }).fadeIn('fast');
    }
  },

  /*
   * Closes the loading box. will only close if there's no api_calls 
   * running at the moment
   */
  hideLoading : function() {
    if (this.has_unfinished_api_calls()) {
      $("#charts_wrapper").busyBox('close'); 
      $("#constraints").busyBox('close');
      //loading.busyBox('close');
    }
  }
});



window.App = App = new AppView();

