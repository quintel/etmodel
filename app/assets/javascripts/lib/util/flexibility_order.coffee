class @FlexibilityOrder
  constructor: (@element) ->
    # pass

  url: (path) ->
    "#{ App.scenario.url_path() }/flexibility_order/#{ path }"

  update: (order) =>
    $.ajax
      url: @url('set'),
      type: 'POST',
      data:
        flexibility_order:
          order: order,
          scenario_id: App.scenario.api_session_id()
      success: ->
        App.call_api()
      error: (e,f) ->
        console.log('Throw error')

  render: =>
    $.ajax
      url: @url('get')
      type: 'GET'
      success: (data) =>
        Sortable.create @element,
          ghostClass: 'ghost'
          animation: 150
          store:
            get: (sortable) ->
              data.order

            set: (sortable) =>
              @update(sortable.toArray().concat(['curtailment']))
