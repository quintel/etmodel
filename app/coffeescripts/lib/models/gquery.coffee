class @Gquery extends Backbone.Model
  initialize : ->
    window.gqueries.add(this)

  result : ->
    present_value = @get('present_value')
    future_value = @get('future_value')

    if !@is_acceptable_value(present_value) && !@is_acceptable_value(future_value)
      console.warn "Gquery #{@get('key')}: #{present_value}/#{future_value}, reset to 0"
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
      @set({
        present_value : api_result, future_value : api_result,
        value : api_result, result_type : 'scalar'})
    else
      @set({
        present_year  : api_result[0][0], present_value : api_result[0][1],
        future_year   : api_result[1][0], future_value  : api_result[1][1],
        result_type : 'array'
      })

  is_acceptable_value : (n) ->
    return true if _.isBoolean(n)
    x = parseInt(n, 10)
    _.isNumber(x) && !_.isNaN(x)

class GqueryList extends Backbone.Collection
  model : Gquery

  # TODO: use find and prevent gquery duplication
  with_key : (gquery_key) ->
    @filter (gquery) => gquery.get('key') == gquery_key

  keys : ->
    keys = window.gqueries.map (gquery) -> gquery.get('key')
    _.compact(keys)

window.gqueries = new GqueryList
