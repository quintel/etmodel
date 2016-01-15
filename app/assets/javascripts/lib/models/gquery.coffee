class @Gquery extends Backbone.Model
  initialize : ->
    window.gqueries.add(this)
    @references = 1

  future_value: -> @get 'future'
  present_value: -> @get 'present'

  safe_present_value: =>
    x = @present_value()
    if @is_acceptable_value(x) then x else 0

  safe_future_value: =>
    x = @future_value()
    if @is_acceptable_value(x) then x else 0

  handle_api_result : (result) ->
    @set
      present: result.present
      future: result.future
      unit : result.unit

  is_acceptable_value : (n) ->
    return true if _.isBoolean(n)
    x = parseInt(n, 10)
    _.isNumber(x) && !_.isNaN(x)

  # cocoa retain-release clone
  retain: => @references += 1
  release: => @references -= 1

class GqueryList extends Backbone.Collection
  model : Gquery

  with_key: (key) => @find (g) -> g.get('key') == key

  keys: => _.compact(@pluck('key'))

  find_or_create_by_key: (key, owner) =>
    if g = @with_key key
      g.retain()
      return g
    else
      return new Gquery
        key: key

  cleanup: =>
    @each (g) =>
      @remove g if g.references == 0

window.gqueries = new GqueryList
