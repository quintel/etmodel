var PolicyGoal = Backbone.Model.extend({
  initialize : function() {
    window.policy_goals.add(this);
    
    this.success_query    = new Gquery({ key: this.get("success_query")});
    this.value_query      = new Gquery({ key: this.get("value_query")});
    this.target_query     = new Gquery({ key: this.get("target_query")});
    this.user_value_query = new Gquery({ key: this.get("user_value_query")});
  },
  
  // shortcut to get the future result for a gquery object
  future_value_for : function(gquery) {
    return gquery.result()[1][1];
  },
  
  // goal achieved? true/false
  success_value : function() {
    return this.future_value_for(this.success_query);
  },
  
  successful : function() {
    return (this.success_value() === true);
  },

  // numeric value
  current_value : function() {
    return this.future_value_for(this.value_query);
  },
  
  // goal, numeric value
  target_value : function() {
    return this.future_value_for(this.target_query);
  },
  
  // returns true if the user has set a goal
  is_set : function() {
    return this.future_value_for(this.user_value_query);
  },
  
  // DEBT: we could use a BB view
  update_view : function() {
    var success = this.successful();

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
  
  format_value : function(n) {
    var out = null;
    
    switch(this.get('display_fmt')) {
      case 'percentage' :
        out = Metric.ratio_as_percentage(n, false, 2);
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
  model : PolicyGoal,

  // returns the number of user set goals
  goals_set : function() {
    return this.select(function(g){ return g.is_set()}).length;
  },

  // returns the number of goals achieved
  goals_achieved : function() {
    return this.select(function(g){ return g.is_set() && g.successful()}).length;
  },

  update_totals : function() {
    var set      = this.goals_set();
    var achieved = this.goals_achieved();
    var string   = "" + achieved + "/" + set;
    $("#constraint_7 strong").html(string);
  }
});

window.policy_goals = new PolicyGoalList();