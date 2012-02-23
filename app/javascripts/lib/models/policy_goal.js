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
    return this.success_query.get('future_value');
  },

  successful : function() {
    return (this.success_value() === true);
  },

  // numeric value
  current_value : function() {
    return this.value_query.get('future_value');
  },

  start_value: function() {
    return this.value_query.get('present_value');
  },

  // goal, numeric value
  target_value : function() {
    return this.target_query.get('future_value');
  },

  // returns true if the user has set a goal
  is_set : function() {
    return this.user_value_query.get('future_value');
  },

  // DEBT: we could use a BB view
  update_view : function() {
    var success = this.successful();

    if(this.is_set()) {
      var check_box = this.dom_element().find(".check");
      check_box.removeClass('success failure not_set');
      check_box.addClass(success ? 'success' : 'failure');

      var formatted = this.format_value(this.target_value());
      this.dom_element().find(".target").html(formatted);
    } else {
      this.dom_element().find(".target").html(I18n.t('policy_goals.not_set'));
    }

    var current_value = this.format_value(this.current_value());
    this.dom_element().find(".you").html(current_value);
    this.update_score_box();
  },

  update_score_box: function() {
    var key = this.get('key');

    // update score box if present
    // policy goal keys and constraint key sometimes don't match. DEBT
    if (key == 'co2_emission') { key = 'co2_reduction'; }
    $("#" + key + "-score").html(this.score());
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
        break;
    }
    return out;
  },

  score: function() {
    if (!this.is_set()) return false;
    var base = this.start_value();
    var current = this.current_value();
    var target = this.target_value();
    var ampl = 100;
    var t = current - base;
    var a = 2 * Math.abs(base - target);
    var score = 2 * ampl * Math.abs( (t / a) - Math.floor( (t / a) + 0.5));
    
    if(t > a || t < 0) { score = -score; }
    if((t < -0.5 * a) || (t > 1.5 * a)) { score = -100; }
  
    // co2 emissions goal works in the opposite direction
    if (this.get('key') == 'co2_emission') { score = -score; }
    return parseInt(score, 10);
  }

});

var PolicyGoalList = Backbone.Collection.extend({
  model : PolicyGoal,

  // returns the number of user set goals
  goals_set : function() {
    return this.select(function(g){ return g.is_set();}).length;
  },

  // returns the number of goals achieved
  goals_achieved : function() {
    return this.select(function(g){ return g.is_set() && g.successful();}).length;
  },

  update_totals : function() {
    var set      = this.goals_set();
    var achieved = this.goals_achieved();
    var string   = "" + achieved + "/" + set;
    $("#constraint_7 strong").html(string);
    this.update_total_score();
  },

  // used by watt-nu. Sums the partial scores
  update_total_score: function() {
    var els;
    switch(App.settings.get('current_round')) {
      case '1':
        els = ['co2_emission'];
        break;
      case '2':
        els = ['co2_emission', 'total_energy_cost'];
        break;
      case '3':
        els = ['co2_emission', 'total_energy_cost', 'renewable_percentage'];
        break;
      default:
        els = [];
        break;
    }

    var items = this.select( function(g){ return g.is_set() && _.include(els, g.get('key')); });
    var total = 0;
    _.each(items, function(g){ total += g.score();});
    $("#targets_met-score").html(total);
    return total;
  }
});

window.policy_goals = new PolicyGoalList();
