D3.import_export =
  View: class extends D3ChartView
    initialize: ->
      D3ChartView.prototype.initialize.call(this)

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

    draw: =>
      # Set maximum x and y values

      @maximum_x = 24
      @maximum_y = 2e6

      # Prepare chart data
      a_2010_curve = [{"x": 1, "y": 1055207.574},{"x": 2, "y": 786041.0055},{"x": 3, "y": 629867.3469},{"x": 4, "y": 564542.7396},{"x": 5, "y": 538348.2435},{"x": 6, "y": 576407.0521},{"x": 7, "y": 650010.3733},{"x": 8, "y": 814391.3466},{"x": 9, "y": 1119398.413},{"x": 10, "y": 1302460.365},{"x": 11, "y": 1434266.447},{"x": 12, "y": 1331817.502},{"x": 13, "y": 1225930.832},{"x": 14, "y": 1238980.572},{"x": 15, "y": 1192905.693},{"x": 16, "y": 1209121.802},{"x": 17, "y": 1281896.649},{"x": 18, "y": 1318890.253},{"x": 19, "y": 1345565.392},{"x": 20, "y": 1453072.873},{"x": 21, "y": 1632181.142},{"x": 22, "y": 1809622.942},{"x": 23, "y": 1498539.871},{"x": 24, "y": 1158395.253}]

      a_double_renewables_curve = [{"x": 1, "y": 698161.0865},{"x": 2, "y": 437619.0481},{"x": 3, "y": 181120.158},{"x": 4, "y": 138443.3191},{"x": 5, "y": 152289.7918},{"x": 6, "y": 223486.4708},{"x": 7, "y": 299074.0513},{"x": 8, "y": 408201.7201},{"x": 9, "y": 649037.8083},{"x": 10, "y": 717758.1545},{"x": 11, "y": 765005.1539},{"x": 12, "y": 644663.7416},{"x": 13, "y": 537552.8574},{"x": 14, "y": 543151.068},{"x": 15, "y": 482230.4129},{"x": 16, "y": 512351.6848},{"x": 17, "y": 610044.8521},{"x": 18, "y": 758932.0001},{"x": 19, "y": 859546.0732},{"x": 20, "y": 976726.6218},{"x": 21, "y": 1110471.475},{"x": 22, "y": 1286475.781},{"x": 23, "y": 1033245.195},{"x": 24, "y": 659887.5631}]

      a_2010_curve = filter_on_y_values a_2010_curve, @maximum_y
      a_double_renewables_curve  = filter_on_y_values a_double_renewables_curve, @maximum_y

      theData = [{color: "#00BFFF", values: a_2010_curve, label: "output_elements.import_export_renewables_chart.a_2010"}, {color: "#F5C400", values: a_double_renewables_curve, label: "output_elements.import_export_renewables_chart.a_double"}]

      # Create SVG convas and set related variables
      [@width, @height] = @available_size()

      legend_columns = 2
      legend_rows = theData.length / legend_columns
      legend_height = legend_rows * @legend_cell_height
      legend_column_width = @width/legend_columns
      legend_margin = 50
      cell_height = @legend_cell_height

      @series_height = @height - legend_height - legend_margin

      @svg = @create_svg_container @width, @height, @margins

      # Define scales and create axes
      xScale = d3.scale.linear()
                       .domain([0, @maximum_x])
                       .range([0, @width])

      yScale = d3.scale.linear()
                       .domain([0, @maximum_y])
                       .range([@series_height, 0])

      xAxis = d3.svg.axis()
                    .scale(xScale)
                    .orient("bottom")

      yAxis = d3.svg.axis()
                    .scale(yScale)
                    .orient("left")
                    .tickValues([])
                    .tickSize(0)

      xAxisGroup = @svg.append("g")
                       .attr("class", "x_axis")
                       .attr("transform", "translate(0,#{@series_height})")
                       .call(xAxis)

      yAxisGroup = @svg.append("g")
                       .attr("class", "y_axis")
                       .call(yAxis)

      xAxisLabel = xAxisGroup.append("text")
                             .attr("class","label")
                             .attr("x", @width/2)
                             .attr("y", 35)
                             .text("#{I18n.t('output_elements.import_export_renewables_chart.x_label')}")
                             .attr("text-anchor","middle")

      yAxisLabel = yAxisGroup.append("text")
                             .attr("class","label")
                             .attr("x", 0 - (@series_height/2))
                             .attr("y", 0 - 25)
                             .text("#{I18n.t('output_elements.import_export_renewables_chart.y_label')}")
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
          .append('path')
          .attr("d", (d) -> lineFunction(d.values) )
          .attr("stroke", (d) -> d.color )
          .attr("stroke-width", 3)
          .attr("fill", "none")

      # Create legend
      legendGroup = @svg.append("g")
                        .attr("class", "legend")
                        .attr("transform", "translate(0,#{@series_height + legend_margin})")

      legendItem = legendGroup.append("svg")

      legendItem.selectAll('rect')
                .data(theData)
                .enter()
                .append('rect')
                .attr("x", (d,i) -> i%2 * legend_column_width )
                .attr("y", (d,i) -> Math.floor(i / 2) * cell_height )
                .attr("width", "10")
                .attr("height", "10")
                .attr("fill", (d) -> d.color )
      
      legendItem.selectAll('text')
                .data(theData)
                .enter()
                .append('text')
                .attr("class", "legend_label")
                .attr("x", (d,i) -> i%2 * legend_column_width + 15 )
                .attr("y", (d,i) -> Math.floor(i / 2) * cell_height + 10 )
                .text((d) -> "#{I18n.t(d.label)}" )


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
                           .interpolate("none")
