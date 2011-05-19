var PolicyGoal = Backbone.Model.extend({
  initialize : function() {
    window.policy_goals.add(this);
    this.reached_query = new Gquery({ key: this.get("reached_query")}); // returns boolean
    this.value_query   = new Gquery({ key: this.get("value_query")});   // returns value
  },
  
  success : function() {
    var res = this.reached_query.result()[0][1];
    return res;
  },
  
  current_value : function() {
    var res = this.value_query.result()[0][1];
    return res;
  },
  
  update_view : function() {
    var success = this.success() === true;
    var template = $("<span>")
    template.append(success ? 'V' : 'X');
    template.css('color', success ? 'green' : 'red');
    this.dom_element().find(".check").html(template);
    
    var current_value = this.current_value();
    this.dom_element().find(".you").html(current_value);    
  },
  
  is_set : function() {
    return false;
  },
  
  dom_element : function() {
    return $("#goal_" + this.get("goal_id"));
  }

});

var PolicyGoalList = Backbone.Collection.extend({
  model : PolicyGoal
});

window.policy_goals = new PolicyGoalList();