
window.AppView = Backbone.View.extend({
  API_URL : globals.api_url,

  initialize : function() {
    _.bindAll(this, 'api_result', 'handleInputElementsUpdate');

    // Jaap MVC legacy
    this.inputElementsController = window.input_elements;
    this.municipalityController = new MunicipalityController();
    this.transitionpriceController = new TransitionpriceController();

    var func = $.proxy(this.handleInputElementsUpdate);
    this.inputElementsController.bind("change", func);

    this.scenario = new Scenario();
  },

  call_api : function(input_params) {
    var url = this.scenario.query_url(input_params);
    var params = {'result' : window.gqueries.keys() };

    LockableFunction.setLock('call_api');
    // TODO: consider using jquery.jsonp plugin
    // http://code.google.com/p/jquery-jsonp/
    $.ajax({
      url: url,
      data: params,
      crossDomain: true,
      dataType: "jsonp",
      success: this.handle_api_result,
      error: function() { console.log("Something went wrong"); }
    });
  },

  // The following method could need some refactoring
  // e.g. el.set({ api_result : value_arr })
  // window.charts.first().trigger('change');
  // window.dashboard.trigger('change');
  handle_api_result : function(data) {
    LockableFunction.removeLock('call_api');
    var result   = data.result;   // Results of this request for every "result[]" parameter

    $.each(result, function(gquery_key, value_arr) { 
      $.each(window.gqueries.with_key(gquery_key), function(i, gquery) {
        gquery.handle_api_result(value_arr);
      });
    });
    window.charts.each(function(chart) { chart.trigger('change'); });
    window.input_elements.init_legacy_controller();

    $("body").trigger("dashboardUpdate");
  },

  /**
   * Set the update in a cancelable action
   */
  handleInputElementsUpdate:function() {
    var func = $.proxy(this.doUpdateRequest, this);
    var lockable_function = function() { LockableFunction.deferExecutionIfLocked('update', func)};
    Util.cancelableAction('update',  lockable_function, {'sleepTime':500});
  },
  
  
  /**
   * Get the value of all changed sliders. Get the chart. Sends those values to the server.
   */
  doUpdateRequest:function() {
    var dirtyInputElements = window.input_elements.dirty();

    if(dirtyInputElements.length == 0)
      return;

    window.App.call_api(window.input_elements.api_update_params());

    window.input_elements.reset_dirty();
  }
});

window.App = new AppView();

