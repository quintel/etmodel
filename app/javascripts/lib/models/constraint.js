// Dash ---------------------------------------------------------------

var Constraint = Backbone.Model.extend({
  initialize : function() {
    // we need this so that the following works: this.gquery.bind('change', this.update_value );
    _.bindAll(this, 'update_values');

    this.gquery = new Gquery({key : this.get('gquery_key')});
    // let gquery notify the constraint, when it has changed.
    this.gquery.bind('change', this.update_values );
    // this.update_values() will change attributes diff and result
    // => this will trigger a 'change' event on this object
    // ==> as ConstraintView binds the 'change' event, it will update itself.

    new ConstraintView({model : this});
  },

  calculate_diff : function(new_result) {
    var previous_result = this.get('result');
    if (previous_result != undefined) {
      return previous_result - new_result;
    } else {
      return null;
    }
  },

  // Apply any last-minute fixes to the result.
  // Uses the future_value as default
  calculate_result : function() {
    var fut = this.gquery.get('future_value');
    var now = this.gquery.get('present_value');

    if (this.get('key') == 'total_primary_energy' ) {
      return Metric.calculate_performance(now, fut); }
    else { 
      return fut; 
    } 
  },

  // Update the result and diff, based on new gquery results
  update_values : function() {
    var new_result = this.calculate_result();
    var new_diff = this.calculate_diff(new_result);
    this.set({
      result : new_result,
      diff : new_diff
    });
  }
});

var Dashboard = Backbone.Collection.extend({
  model : Constraint
});
window.dashboard = new Dashboard();