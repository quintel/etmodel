var PolicyGoal = Backbone.Model.extend({
  initialize : function() {
    window.policy_goals.add(this);
    
    this.success_query    = new Gquery({ key: this.get("success_query")});
    this.value_query      = new Gquery({ key: this.get("value_query")});
    this.target_query     = new Gquery({ key: this.get("target_query")});
    this.user_value_query = new Gquery({ key: this.get("user_value_query")});
  },
  
  // goal achieved? true/false
  success_value : function() {
    var res = this.success_query.result()[0][1];
    return res;
  },
  
  // numeric value
  current_value : function() {
    var res = this.value_query.result()[1][1];
    return res;
  },
  
  // goal, numeric value
  target_value : function() {
    var res = this.target_query.result()[1][1];
    return res;
  },
  
  // returns true if the user has set a goal
  is_set : function() {
    var res = this.user_value_query.get("future_value");
    return res != null;
  },

  // DEBT: we could use a BB view
  update_view : function() {
    var success = this.success_value() === true;

    if(this.is_set()) {
      var template = $("<span>")
      template.append(success ? 'V' : 'X');
      template.css('color', success ? 'green' : 'red');
      this.dom_element().find(".check").html(template);

      var formatted = this.format_value(this.target_value());
      this.dom_element().find(".target").html(formatted);
    }
    
    var current_value = this.format_value(this.current_value());
    this.dom_element().find(".you").html(current_value);    
  },
  
  dom_element : function() {
    return $("#goal_" + this.get("goal_id"));
  },
  
  // TODO: move to metric.js as much as possible
  format_value : function(n) {
    var out = null;
    switch(this.get('display_fmt')) {
      case 'percentage' :
        out = "" + Metric.round_number(n * 100, 2) + "%";
        break;
      case 'number':
        out = Metric.round_number(n, 2);
        break;
      case 'number_with_unit':
        out = "" + Metric.round_number(n, 2) + " " + this.get('unit');
        break;
      default:
        out = n;
    }
    return out;
  }

});

var PolicyGoalList = Backbone.Collection.extend({
  model : PolicyGoal
});

window.policy_goals = new PolicyGoalList();