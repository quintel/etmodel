class @FlexibilityOrder
  constructor: (@element) ->
    @lastGood = null

  url: ->
    "#{App.scenario.url_path()}/flexibility_order"

  update: (sortable) =>
    options = sortable.toArray()

    $.ajax
      url: @url(),
      type: 'POST',
      data:
        flexibility_order:
          order: options
      success: =>
        App.call_api()
        @lastGood = options
      error: (e,f) =>
        if @lastGood
          sortable.sort(@lastGood)

  render: =>
    $.ajax
      url: @url()
      type: 'GET'
      success: (data) =>
        Sortable.create @element,
          ghostClass: 'ghost'
          animation: 150
          store:
            get: (_sortable) =>
              @lastGood = data.order
              data.order

            set: (sortable) =>
              @update(sortable)
