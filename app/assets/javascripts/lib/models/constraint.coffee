# DashboardItem would be a better name
#
class Constraint extends Backbone.Model
  initialize: ->
    @gquery = gqueries.find_or_create_by_key @get('gquery_key')
    # let gquery notify the constraint, when it has changed.
    @gquery.bind('change', @update_values )
    # @update_values() will change attributes previous_result and result
    # => this will trigger a 'change' event on this object
    # ==> as ConstraintView binds the 'change' event, it will update itself.
    new ConstraintView({model : this})

  calculate_diff : (new_result, previous_result) ->
    if previous_result != undefined
      return Metric.round_number((new_result - previous_result), 3)
    else
      return null

  # Apply any last-minute fixes to the result.
  # Uses the future_value as default
  calculate_result: =>
    fut = @gquery.get('future')
    now = @gquery.get('present')
    switch @get('key')
      when 'total_primary_energy', 'employment'
        return Metric.calculate_performance(now, fut)
      when 'profitability'
        MeritOrder.dashboardValue(fut)
      else
        return fut

  # Update the result and previous result, based on new gquery result
  update_values : =>
    # set the result to previous result before calculating the new one
    previous_result = @get('result')
    result = @calculate_result()
    @set({
      previous_result : previous_result
      result : result
    })

  # All dashboard items show the value of the gquery they've been assigned.
  # But there's one exception...
  result: ->
    if @get('key') == 'profitability'
      MeritOrder.dashboardValue(@gquery.get('future'))
    else
      @get('result')

  error: ->
    x = @result()
    x == 'debug' || x == 'airbrake' || _.isNaN(x)

class Dashboard extends Backbone.Collection
  model : Constraint

  find_by_key: (key) => @find (g) -> g.get('key') == key

window.dashboard = new Dashboard()
