D3.solar_curtailment_curve =
  View: class extends D3.dynamic_demand_curve.View
    downsampleWith: 'max'

    draw: ->
      super

      @serieSelect = new D3ChartSerieSelect(@container_selector(),
                                            @serieSelectOptions())
      @serieSelect.draw(@refresh.bind(this))

    # When a slider is (re)set to zero while showing in the chart,
    # the zeroed series will remain in the chart data as there is
    # no new data to overwrite it. Because the series still appears in
    # the legend, its opcatiy is NOT set to 0. Therefore all g.series
    # are removed to ensure a full redraw.
    initialDraw: (xScale, yScale, area, line) ->
      @svg.selectAll('g.serie').remove()

      super(xScale, yScale, area, line)

    visibleData: ->
      val = @serieSelect?.selectBox.val() || @serieSelectOptions()[0]
      super().filter((serie) -> serie.key.includes(val))

    getLegendSeries: ->
      legendSeries = []
      val = @serieSelect.selectBox.val()
      @series.forEach (serie) ->
        if serie.attributes.gquery_key.includes(val)
          legendSeries.push(serie)

      legendSeries

    serieSelectOptions: ->
      return ['solar_pv',
             'households_solar_pv',
             'buildings_solar_pv',
             'energy_power_solar_pv']
