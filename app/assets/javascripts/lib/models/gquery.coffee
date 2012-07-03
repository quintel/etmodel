class @Gquery extends Backbone.Model
  initialize : ->
    window.gqueries.add(this)
    @references = 1

  result : ->
    present_value = @get('present_value')
    future_value = @get('future_value')

    if !@is_acceptable_value(present_value) && !@is_acceptable_value(future_value)
      # console.warn "Gquery #{@get('key')}: #{present_value}/#{future_value}, reset to 0"
      present_value = 0
      future_value  = 0

    [ [@get('present_year'), present_value], [@get('future_year'), future_value] ]

  future_value: -> @get 'future_value'
  present_value: -> @get 'present_value'

   # api_result is either
   # - Number: when adding present:V(...)
   # - Array: normal GQL Queries
  handle_api_result : (api_result) ->
    if !(api_result instanceof Array)
      @set
        present_value : api_result
        future_value : api_result
        value : api_result
        result_type : 'scalar'
    else
      @set
        present_year: api_result[0][0], present_value : api_result[0][1]
        future_year : api_result[1][0], future_value  : api_result[1][1]
        result_type : 'array'

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
