D3.solar_curtailment_curve =
  View: class extends D3.dynamic_demand_curve.View
    downsampleWith: 'max'

    draw: ->
      super

      @serieSelect = new D3ChartSerieSelect(@container_selector(),
                                            @serieSelectOptions())
      @serieSelect.draw(@refresh.bind(this))

    refresh: ->
      super()

      # Update each series tooltip and fill since the paths are re-used when a
      # new series is selected.
      @svg.selectAll('g.serie')
        .selectAll('path')
        .attr('class', (data) -> "area " + data.key)
        .attr('fill', (data) -> data.color )
        .attr('data-tooltip-text', (d) -> d.label)

    # When a slider is (re)set to zero while showing in the chart,
    # the zeroed series will remain in the chart data as there is
    # no new data to overwrite it. Because the series still appears in
    # the legend, its opcatiy is NOT set to 0. Therefore all g.series
    # are removed to ensure a full redraw.
    initialDraw: (xScale, yScale, area, line) ->
      @svg.selectAll('g.serie').remove()

      super(xScale, yScale, area, line)

    visibleData: ->
      val = @serieSelect?.selectBox.val() || @serieSelectOptions()[0].match
      super().filter((serie) -> serie.key.includes(val))

    getLegendSeries: ->
      legendSeries = []
      val = @serieSelect.selectBox.val()
      @series.forEach (serie) ->
        if serie.attributes.gquery_key.includes(val)
          legendSeries.push(serie)

      legendSeries

    serieSelectOptions: ->
      if (@model.get('config') && @model.get('config').serie_selections)
        @model.get('config').serie_selections.map((option) -> { match: option })
      else
        _(@series)
          .sortBy((serie) -> serie.get('label').toLowerCase())
          .map((serie) -> {
            match: serie.get('gquery_key'),
            name: serie.get('label'),
            group: serie.get('group')
          })
