var PolicyGoal = Backbone.Model.extend({
  initialize : function() {
    window.policy_goals.add(this);
    this.gquery = new Gquery({ key: this.get("reached_query")});
  },
  
  result : function() {
    var res = this.gquery.result()[0][1];
    return res;
  },
  
  update_view : function() {
    this.dom_element().find(".check").html(this.result());
    this.dom_element().find(".gquery").html(this.gquery.get("key"));
  },
  
  dom_element : function() {
    return $("#goal_" + this.get("goal_id"));
  }

});

var PolicyGoalList = Backbone.Collection.extend({
  model : PolicyGoal
});

window.policy_goals = new PolicyGoalList();