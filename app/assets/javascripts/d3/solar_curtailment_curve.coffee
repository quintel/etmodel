D3.solar_curtailment_curve =
  View: class extends D3.dynamic_demand_curve.View


    draw: ->
      @serieSelect = new D3ChartSerieSelect(@container_selector(),
                                            ['solar_pv',
                                             'buildings_solar_pv',
                                             'households_solar_pv',
                                             'energy_power_solar_pv'])
      @serieSelect.draw(@refresh.bind(this))

      super

    visibleData: ->
      val = @serieSelect.selectBox.val()
      super().filter((serie) -> serie.key.includes(val))

    getLegendSeries: ->
      legendSeries = []
      val = @serieSelect.selectBox.val()
      @series.forEach (serie) =>
         if serie.attributes.gquery_key.includes(val)
           legendSeries.push(serie)

      legendSeries


# TODO
# generate options instead of putting them in hard
# translations of options
# tooltips
# link the table view

