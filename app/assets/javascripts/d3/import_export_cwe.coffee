D3.import_export_cwe =
  View: class extends D3ChartView
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @gquery = gqueries.find_or_create_by_key('installed_capacity_solar_and_wind')

    can_be_shown_as_table: -> false

    margins :
      top: 20
      bottom: 50
      left: 50
      right: 20

    filter_on_y_values = (data, max) =>
      result = []
      result.push(d) for d in data when d.y <= max
      return result

    formatDay = (d,i) -> if i <= 13 then i + 8 else ""

    draw: =>
      # Set maximum x and y values

      @maximum_x = 28
      @maximum_y = 60

      # Prepare chart data
      APX_DAM = [{"x": "1", "y": "47.01"}, {"x": "3", "y": "49.14"}, {"x": "5", "y": "50.98"}, {"x": "7", "y": "46.17"}, {"x": "9", "y": "38.06"}, {"x": "11", "y": "47.25"}, {"x": "13", "y": "49.81"}, {"x": "15", "y": "46.60"}, {"x": "17", "y": "45.58"}, {"x": "19", "y": "43.19"}, {"x": "21", "y": "40.68"}, {"x": "23", "y": "43.99"}, {"x": "25", "y": "52.66"}, {"x": "27", "y": "51.36"}]

      Belpex_DAM = [{"x": "1", "y": "42.40"}, {"x": "3", "y": "41.21"}, {"x": "5", "y": "49.75"}, {"x": "7", "y": "42.32"}, {"x": "9", "y": "30.34"}, {"x": "11", "y": "46.20"}, {"x": "13", "y": "49.20"}, {"x": "15", "y": "46.36"}, {"x": "17", "y": "44.04"}, {"x": "19", "y": "39.54"}, {"x": "21", "y": "32.24"}, {"x": "23", "y": "34.75"}, {"x": "25", "y": "51.90"}, {"x": "27", "y": "51.36"}]

      EPEX_Spot_FR = [{"x": "1", "y": "41.6"}, {"x": "3", "y": "41.21"}, {"x": "5", "y": "48.97"}, {"x": "7", "y": "42.32"}, {"x": "9", "y": "29.98"}, {"x": "11", "y": "44.43"}, {"x": "13", "y": "49.2"}, {"x": "15", "y": "46.36"}, {"x": "17", "y": "41.83"}, {"x": "19", "y": "38.19"}, {"x": "21", "y": "31.63"}, {"x": "23", "y": "33.25"}, {"x": "25", "y": "50.88"}, {"x": "27", "y": "51.36"}]

      EPEX_Spot_DE = [{"x": "1", "y": "33.49"}, {"x": "3", "y": "31.13"}, {"x": "5", "y": "28.31"}, {"x": "7", "y": "29.66"}, {"x": "9", "y": "19.59"}, {"x": "11", "y": "41.94"}, {"x": "13", "y": "49.35"}, {"x": "15", "y": "45.69"}, {"x": "17", "y": "40.75"}, {"x": "19", "y": "39.58"}, {"x": "21", "y": "31.87"}, {"x": "23", "y": "24.69"}, {"x": "25", "y": "48.52"}, {"x": "27", "y": "49.51"}]

      theData = [{color: "#00BFFF", values: APX_DAM, label: "APX DAM (NL)"}, {color: "#1947A8", values: Belpex_DAM , label: "Belpex DAM (BE)"}, {color: "#F5C400", values: EPEX_Spot_FR, label: "EPEX Spot FR"}, {color: "#DB2C18", values: EPEX_Spot_DE, label: "EPEX Spot DE"}]

      # Create SVG convas and set related variables
      [@width, @height] = @available_size()

      legend_columns = 2
      legend_rows = theData.length / legend_columns
      legend_height = legend_rows * @legend_cell_height
      legend_column_width = @width/ legend_columns
      legend_margin = 50
      cell_height = @legend_cell_height

      @series_height = @height - legend_height - legend_margin

      @svg = @create_svg_container @width, @height, @margins

      # Define scales and create axes
      xScale = d3.scale.linear()
                       .domain([0, @maximum_x])
                       .range([0, @width])

      yScale = d3.scale.linear()
                       .domain([10, @maximum_y])
                       .range([@series_height, 0])

      xAxis = d3.svg.axis()
                    .scale(xScale)
                    .orient("bottom")
                    .tickFormat(formatDay)

      yAxis = d3.svg.axis()
                    .scale(yScale)
                    .orient("left")
                    .tickValues([10,20,30,40,50,60])
                    .tickSize(0)

      xAxisGroup = @svg.append("g")
                       .attr("class", "x_axis")
                       .attr("transform", "translate(0,#{@series_height})")
                       .call(xAxis)

      yAxisGroup = @svg.append("g")
                       .attr("class", "y_axis")
                       .call(yAxis)

      xAxisGroup.selectAll('text').attr('transform', 'translate(20,0)')

      xAxisLabel = xAxisGroup.append("text")
                             .attr("class","label")
                             .attr("x", @width/ 2)
                             .attr("y", 35)
                             .text("#{I18n.t('output_elements.cwe_chart.date')}")
                             .attr("text-anchor","middle")

      yAxisLabel = yAxisGroup.append("text")
                             .attr("class","label")
                             .attr("x", 0 - (@series_height/ 2))
                             .attr("y", 0 - 25)
                             .text("#{I18n.t('output_elements.cwe_chart.DAM_price')}")
                             .attr("text-anchor","middle")
                             .attr("transform", (d) -> "rotate(-90)" )

      lineFunction = d3.svg.line()
                           .x( (d) ->  xScale(d.x) )
                           .y( (d) ->  yScale(d.y) )
                           .interpolate("none")

      # Draw lines, using data binding
      @svg.selectAll('path.serie')
          .data(theData)
          .enter()
          .append('g')
          .attr('id', (d,i) -> 'path_' + i)
          .append('path')
          .attr("d", (d) -> lineFunction(d.values) )
          .attr("stroke", (d) -> d.color )
          .attr("stroke-width", 3)
          .attr("fill", "none")

      markers = for data, i in theData
        @svg.select('g#path_' + i).selectAll('circle')
            .data(data.values)
            .enter()
            .append('circle')
            .attr(
              cx: (d) -> parseInt(xScale(d.x)),
              cy: (d) -> parseInt(yScale(d.y)),
              r: 5,
              fill: data.color,
              stroke: 'rgb(255,255,255)',
              'stroke-width': 2
              )

      # Draw 'Indicative' label
      @svg.append("text")
          .attr("class", "indicative_label")
          .text("#{I18n.t('output_elements.storage_chart.indicative')}")
          .attr("transform", "translate(#{@width - 80},0) rotate(45)" )

      # Create legend
      legendGroup = @svg.append("g")
                        .attr("class", "legend")
                        .attr("transform", "translate(0,#{@series_height + legend_margin})")

      legendItem = legendGroup.append("svg")

      # legendItem.selectAll('rect')
      #           .data(theData)
      #           .enter()
      #           .append('rect')
      #           .attr("x", (d,i) -> i%2 * legend_column_width + 5)
      #           .attr("y", (d,i) -> Math.floor(i / 2) * cell_height )
      #           .attr("width", "10")
      #           .attr("height", "10")
      #           .attr("fill", (d) -> d.color )
                

      legendItem.selectAll('line')
                .data(theData)
                .enter()
                .append('line')
                .attr("x1", (d,i) -> i%2 * legend_column_width )
                .attr("y1", (d,i) -> Math.floor(i / 2) * cell_height + 5)
                .attr("x2", (d,i) -> i%2 * legend_column_width + 20)
                .attr("y2", (d,i) -> Math.floor(i / 2) * cell_height + 5)
                .attr("stroke-width", 3)
                .attr("stroke", (d) -> d.color)
                .attr("fill", "none")

      legendItem.selectAll('circle')
                .data(theData)
                .enter()
                .append('circle')
                .attr(
                    cx: (d,i) -> i%2 * legend_column_width + 10,
                    cy: (d,i) -> Math.floor(i / 2) * cell_height + 5,
                    r: 5,
                    fill: (d) -> d.color,
                    stroke: "rgb(255,255,255)",
                    'stroke-width': 2
                    )

      legendItem.selectAll('text')
                .data(theData)
                .enter()
                .append('text')
                .attr("class", "legend_label")
                .attr("x", (d,i) -> i%2 * legend_column_width + 35 )
                .attr("y", (d,i) -> Math.floor(i / 2) * cell_height + 10 )
                .text((d) -> "#{d.label}" )

    refresh: =>
      # Define scales and line function
      xScale = d3.scale.linear()
                       .domain([0, @maximum_x])
                       .range([0, @width])

      yScale = d3.scale.linear()
                       .domain([0, @maximum_y])
                       .range([@series_height, 0])

      lineFunction = d3.svg.line()
                           .x( (d) ->  xScale(d.x) )
                           .y( (d) ->  yScale(d.y) )
                           .interpolate("basis")
