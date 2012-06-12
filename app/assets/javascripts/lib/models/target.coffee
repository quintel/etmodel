class @Target extends Backbone.Model
  initialize : ->
    window.targets.add(this)
    @success_query    = gqueries.find_or_create_by_key @get("success_query")
    @value_query      = gqueries.find_or_create_by_key @get("value_query")
    @target_query     = gqueries.find_or_create_by_key @get("target_query")
    @user_value_query = gqueries.find_or_create_by_key @get("user_value_query")

  # goal achieved? true/false
  success_value: => @success_query.get('future_value')

  successful: => @success_value() == true

  # numeric value
  current_value: => @value_query.get('future_value')

  start_value: => @value_query.get('present_value')

  # goal, numeric value
  target_value: => @target_query.get('future_value')

  # returns true if the user has set a goal
  is_set: => @user_value_query.get('future_value')

  # DEBT: we could use a BB view
  update_view: =>
    if @is_set()
      check_box = @dom_element().find(".check")
      check_box.removeClass('success failure not_set')
      check_box.addClass(if @successful() then 'success' else 'failure')
      formatted = @format_value(@target_value())
      @dom_element().find(".target").html(formatted)
    else
      @dom_element().find(".target").html(I18n.t('targets.not_set'))
    current_value = @format_value(@current_value())
    @dom_element().find(".you").html(current_value)
    @update_score_box()

  update_score_box: =>
    key = @get('key')
    # update score box if present
    # policy goal keys and constraint key sometimes don't match. DEBT
    key = 'co2_reduction' if key == 'co2_emission'
    $("##{key}-score").html(@score())

  dom_element: => $("#goal_" + @get("goal_id"))

  format_value: (n) =>
    switch @get('display_fmt')
      when 'percentage'
        return Metric.ratio_as_percentage(n, false, 2)
      when 'number'
        return Metric.round_number(n, 2)
      when 'number_with_unit'
        return "" + Metric.round_number(n, 2) + " " + @get('unit')
      else
        return n

  score: =>
    return false if !@is_set()
    start = @start_value()
    current = @current_value()
    target = @target_value()
    ampl = 100
    t = current - start
    t = -t if target < start

    a = 2 * Math.abs(start - target)
    score = 2 * ampl * Math.abs( (t / a) - Math.floor( (t / a) + 0.5))
    score = - score if (t > a || t < 0)
    score = -100 if ((t < -0.5 * a) || (t > 1.5 * a))
    Math.round(score)

class @TargetList extends Backbone.Collection
  model : Target

  # returns the number of user set goals
  targets_set: => (@select (g) -> g.is_set()).length

  # returns the number of goals achieved
  targets_achieved: => (@select (g) -> g.is_set() && g.successful()).length

  update_totals: =>
    string = "#{@targets_achieved()}/#{@targets_set()}"
    $("#constraint_7 strong").html(string)

  total_score: =>
    total = 0
    els = []
    current_round = parseInt(App.settings.get('current_round'))
    switch current_round
      when 1
        els = ['co2_emission']
      when 2
        els = ['co2_emission', 'total_energy_cost']
      when 3
        els = ['co2_emission', 'total_energy_cost', 'renewable_percentage']
    goals = this
    _.each els, (key) ->
      g = goals.find_by_key(key)
      return if !g
      total += g.score()
    total

  # used by watt-nu. Sums the partial scores
  update_total_score: =>
    @update_score_badges()
    total = @total_score()
    $("#targets_met-score").html(total)
    Tracker.delayed_track({score: total})
    total

  find_by_key: (key) =>
    @filter((g) -> g.get('key') == key)[0]

  update_score_badges: ->
    round = App.settings.get('current_round')
    $(".watt-nu").hide()
    total = 0
    items = []
    if round == 1
      items = ["#co2_reduction-score"]
    else if round == 2
      items = ["#co2_reduction-score", "#total_energy_cost-score"]
    else if (round == 3)
      items = ["#co2_reduction-score", "#total_energy_cost-score", "#renewable_percentage-score"]

    if round
      _.each items, (i) ->
        el = $(i)
        el.show()
      $("#targets_met-score").show()

window.targets= new TargetList()
