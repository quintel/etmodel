class @Target extends Backbone.Model
  initialize : ->
    window.targets.add(this)
    @success_query = gqueries.find_or_create_by_key @get("success_query")
    @value_query   = gqueries.find_or_create_by_key @get("value_query")
    @target_query  = gqueries.find_or_create_by_key @get("target_query")

  # goal achieved? true/false
  success_value: => @success_query.future_value()

  successful: => @success_value() == true

  # numeric value
  current_value: => @value_query.future_value()

  start_value: => @value_query.future_value()

  # goal, numeric value
  target_value: => @target_query.future_value()

  # returns true if the user has set a goal
  is_set: => _.isNumber @target_value()

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

  dom_element: => $("#goal_" + @get("goal_id"))

  format_value: (n) =>
    return null unless _.isNumber(n)
    switch @get('display_fmt')
      when 'percentage'
        return Metric.ratio_as_percentage(n, false, 2)
      when 'number'
        return Metric.round_number(n, 2)
      when 'number_with_unit'
        return "#{Metric.round_number(n, 2)} #{@get('unit')}"
      else
        return n

class @TargetList extends Backbone.Collection
  model : Target

  # returns the number of user set goals
  targets_set: => (@select (g) -> g.is_set()).length

  # returns the number of goals achieved
  targets_achieved: => (@select (g) -> g.is_set() && g.successful()).length

  update_totals: =>
    string = "#{@targets_achieved()}/#{@targets_set()}"
    $("#constraint_7 strong").html(string)

  find_by_key: (key) =>
    @filter((g) -> g.get('key') == key)[0]

window.targets = new TargetList()
