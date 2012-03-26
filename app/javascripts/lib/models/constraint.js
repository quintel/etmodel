var Constraint = Backbone.Model.extend({
  initialize : function() {
    // we need this so that the following works: this.gquery.bind('change', this.update_value );
    _.bindAll(this, 'update_values');

    this.gquery = new Gquery({key : this.get('gquery_key')});
    // let gquery notify the constraint, when it has changed.
    this.gquery.bind('change', this.update_values );
    // this.update_values() will change attributes previous_result and result
    // => this will trigger a 'change' event on this object
    // ==> as ConstraintView binds the 'change' event, it will update itself.

    new ConstraintView({model : this});
  },

  calculate_diff : function(new_result, previous_result) {
    if (previous_result != undefined) {
      return Metric.round_number((new_result - previous_result),4);
    } else {
      return null;
    }
  },

  // Apply any last-minute fixes to the result.
  // Uses the future_value as default
  calculate_result : function() {
    var fut = this.gquery.get('future_value');
    var now = this.gquery.get('present_value');

    switch(this.get('key')) {
      case 'total_primary_energy':
      case 'employment':
        return Metric.calculate_performance(now, fut);
      default:
        return fut;
    }
  },

  // Update the result and previous result, based on new gquery result
  update_values : function() {
    //set the result to previous result before calculating the new one 
    var previous_result = this.get('result');
    var result = this.calculate_result();
    this.set({
      previous_result : previous_result,
      result : result
    });
  },

  result: function() {
    return this.get('result');
  },

  error: function() {
    return (this.result() == 'debug' || this.result() == 'airbrake')
  }
});

var Dashboard = Backbone.Collection.extend({
  model : Constraint
});

window.dashboard = new Dashboard();
