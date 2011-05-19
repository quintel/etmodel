var PolicyGoal = Backbone.Model.extend({
  initialize : function() {
    window.policy_goals.add(this);
    
    this.success_query = new Gquery({ key: this.get("success_query")}); // returns boolean
    this.value_query   = new Gquery({ key: this.get("value_query")});   // returns value
    this.target_query  = new Gquery({ key: this.get("target_query")});  // returns value
  },
  
  success_value : function() {
    var res = this.success_query.result()[0][1];
    return res;
  },
  
  current_value : function() {
    var res = this.value_query.result()[0][1];
    return res;
  },
  
  target_value : function() {
    var res = this.target_query.result()[0][1];
    return res;
  },
  
  // DEBT: we could use a BB view
  update_view : function() {
    var success = this.success_value() === true;
    var template = $("<span>")
    template.append(success ? 'V' : 'X');
    template.css('color', success ? 'green' : 'red');
    this.dom_element().find(".check").html(template);
    
    var current_value = this.format_value(this.current_value());
    this.dom_element().find(".you").html(current_value);    
    
    var target_value = this.format_value(this.target_value());
    this.dom_element().find(".target").html(target_value);    
  },
  
  // TODO
  is_set : function() {
    return false;
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