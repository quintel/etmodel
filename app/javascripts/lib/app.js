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

    // Jaap MVC legacy
    this.inputElementsController = window.input_elements;
    this.inputElementsController.bind("change", this.handleInputElementsUpdate);

    this.municipalityController = new MunicipalityController();

    this.settings = new Setting(); // At this point settings is empty.
    this.scenario = new Scenario();
    this.peak_load = new PeakLoad();
  },

  bootstrap : function() {
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
    var url = this.scenario.query_url(input_params);
    var params = {'result' : window.gqueries.keys() };

    LockableFunction.setLock('call_api');
    showLoading();
    $.jsonp({
      url: url + '?callback=?',
      data: params,
      success: this.handle_api_result,
      error: function() {
        console.log("Something went wrong"); 
        hideLoading();
      }
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
    window.policy_goals.invoke('update_view');
    window.policy_goals.update_totals();
    App.peak_load.trigger('change');

    $("body").trigger("dashboardUpdate");
    hideLoading();
  },

  /**
   * Set the update in a cancelable action
   */
  handleInputElementsUpdate:function() {
    var func = $.proxy(this.doUpdateRequest, this);
    var lockable_function = function() { LockableFunction.deferExecutionIfLocked('update', func); };
    Util.cancelableAction('update',  lockable_function, {'sleepTime':500});
  },
  
  
  /**
   * Get the value of all changed sliders. Get the chart. Sends those values to the server.
   */
  doUpdateRequest:function() {
    var dirtyInputElements = window.input_elements.dirty();

    if(dirtyInputElements.length == 0) { return; }

    window.App.call_api(window.input_elements.api_update_params());
    window.input_elements.reset_dirty();
  }
});


function showLoading() { $("#loading").show(); }
function hideLoading() { $("#loading").hide(); }

window.App = App = new AppView();

