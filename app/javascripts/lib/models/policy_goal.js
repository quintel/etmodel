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
    var success = this.result();
    var template = $("<span>")
    template.append(success ? 'V' : 'X');
    template.css('color', success ? 'green' : 'red');
    console.log(template);
    this.dom_element().find(".check").html(template);
  },
  
  dom_element : function() {
    return $("#goal_" + this.get("goal_id"));
  }

});

var PolicyGoalList = Backbone.Collection.extend({
  model : PolicyGoal
});

window.policy_goals = new PolicyGoalList();