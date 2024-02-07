D3.heat_demand_and_production =
  View: class extends D3YearlyChartView
    class FakeSerie
      constructor: (@key, @color) ->
        # pass

      get: (attribute) ->
        switch attribute
          when 'key' then @key
          when 'color' then @color

    # --------------------------------------------------------------------------

    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    dataForChart: ->
      data = super

      demandVals = _.find(data, (serie) => serie.key == @demandKey).values
      production = _.find(data, (serie) => serie.key == @productionKey)

      surplusVals = new Array(demandVals.length)
      deficitVals = new Array(demandVals.length)

      # Remove from the production series any time when production exceeds
      # demand.
      production.values = production.values.map (amount, index) ->
        demand = demandVals[index]

        if amount < demand
          surplusVals[index] = 0
          deficitVals[index] = demand - amount
          amount
        else
          surplusVals[index] = amount - demand
          deficitVals[index] = 0
          demand

      data.unshift({
        color: '#ffbaba',
        label: I18n.t("output_element_series.labels.#{ @deficitKey }")
        key: @deficitKey,
        skip: false,
        values: deficitVals
      })

      data.unshift({
        color: '#FE6100',
        label: I18n.t("output_element_series.labels.#{ @surplusKey }")
        key: @surplusKey,
        skip: false,
        values: surplusVals
      })

      data

    filterYValue: (value) ->
      value

    draw: ->
      prefix = @keyPrefix()

      @demandKey = prefix + 'demand'
      @productionKey = prefix + 'production'
      @surplusKey = prefix + 'surplus'
      @deficitKey = prefix + 'deficit'

      super
      @drawLegend(@getLegendSeries())

    getLegendSeries: () ->
      legendSeries = @series.filter (serie) ->
        _.find(serie.future_value(), (v) -> v > 0)

      legendSeries.unshift(new FakeSerie(@deficitKey, '#ffbaba'))
      legendSeries.unshift(new FakeSerie(@surplusKey, '#FE6100'))

      legendSeries

    getSeries: ->
      weekNum = this.dateSelect && this.dateSelect.val() || 0

      _.sortBy @model.non_target_series(), (serie) =>
        values = MeritTransformator.sliceValues(serie.future_value(), weekNum)

        min = max = sum = 0

        for value in values
          if value < min then min = value
          if value > max then max = value
          sum += value

        return 0 if sum == 0

        Math.abs((max - min) / sum)

    drawData: (xScale, yScale, area, line) ->
      @svg.selectAll('path.serie')
        .data(@stackedData)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr("class", "serie")
        .append('path')
        .attr('class', (data) -> "area " + data.key)
        .attr('d', (data) -> area(data.values) )
        .attr('fill', (data) -> data.color )
        .attr('data-tooltip-text', (d) -> d.label)

      $("#{@container_selector()} path.area").qtip
        content:
          text:  -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom right'
          at: 'top center'

      @svg.selectAll('path.serie')
        .data(@totalDemand)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr("class", "serie-line")
        .append('path')
        .attr('class', 'line')
        .attr('d', (data) -> line(data.values) )
        .attr('stroke', (data) -> data.color )
        .attr('stroke-width', 1.5)
        .attr('fill', 'none')

    refresh: (xScale, yScale) ->
      super

      @setStackedData()
      @drawLegend(@getLegendSeries())

      xScale = @createTimeScale(@dateSelect.currentRange())
      yScale = @createLinearScale()
      area   = @area(xScale, yScale)
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      if @container_node().find("g.serie").length > 0
        @svg.selectAll('g.serie')
          .data(@stackedData)
          .select('path.area')
          .attr('d', (data) -> area(data.values) )
          .attr('fill', (data) -> data.color )
          .attr('data-tooltip-text', (d) -> d.label)

        @svg.selectAll('g.serie-line')
          .data(@totalDemand)
          .select('path.line')
          .attr('d', (data) -> line(data.values) )

      else
        @drawData(xScale, yScale, area, line)

    area: (xScale, yScale) ->
      d3.svg.area()
        .x((data) -> xScale(data.x))
        .y0((data) -> yScale(data.y0))
        .y1((data) -> yScale(data.y0 + data.y))
        .interpolate('monotone')

    line: (xScale, yScale) ->
      d3.svg.line()
        .x((data) -> xScale(data.x))
        .y((data) -> yScale(data.y))
        .interpolate('monotone')

    keyPrefix: ->
      models = @model.series.slice(0, 2)

      if models.length < 2 then return ''

      leftKey  = models[0].get('gquery_key')
      rightKey = models[1].get('gquery_key')

      suffix = ''

      for i in [0..Math.min(leftKey.length, rightKey.length)]
        if leftKey[i] == rightKey[i]
          suffix += leftKey[i]
        else
          break

      suffix
