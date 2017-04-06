D3.import_export_capacity =
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
      @maximum_y = 65

      # Prepare chart data
      a_2010_curve = [{"x": 1, "y": 28.70413257},{"x": 2, "y": 22.62189304},{"x": 3, "y": 19.51633239},{"x": 4, "y": 18.14248171},{"x": 5, "y": 17.57684852},{"x": 6, "y": 19.2486983},{"x": 7, "y": 21.5663164},{"x": 8, "y": 25.06365388},{"x": 9, "y": 32.33975048},{"x": 10, "y": 43.71940068},{"x": 11, "y": 49.1609725},{"x": 12, "y": 41.0612691},{"x": 13, "y": 35.18167868},{"x": 14, "y": 35.62345703},{"x": 15, "y": 34.21690708},{"x": 16, "y": 38.20480327},{"x": 17, "y": 48.34158767},{"x": 18, "y": 54.42327276},{"x": 19, "y": 59.34495965},{"x": 20, "y": 63.82867048},{"x": 21, "y": 62.26360344},{"x": 22, "y": 52.45554925},{"x": 23, "y": 39.56008034},{"x": 24, "y": 31.90527624}]

      b_2010_curve = [{"x": 1, "y": 28.03187804},{"x": 2, "y": 22.62189304},{"x": 3, "y": 19.51633239},{"x": 4, "y": 18.14248171},{"x": 5, "y": 17.57684852},{"x": 6, "y": 20.34651091},{"x": 7, "y": 23.73980705},{"x": 8, "y": 27.58908828},{"x": 9, "y": 33.79112448},{"x": 10, "y": 35.86227986},{"x": 11, "y": 39.07025259},{"x": 12, "y": 34.97365583},{"x": 13, "y": 31.70807446},{"x": 14, "y": 31.98262117},{"x": 15, "y": 31.05007041},{"x": 16, "y": 32.54786859},{"x": 17, "y": 36.94571447},{"x": 18, "y": 39.48374295},{"x": 19, "y": 41.50001335},{"x": 20, "y": 44.16967381},{"x": 21, "y": 47.43619937},{"x": 22, "y": 50.70305883},{"x": 23, "y": 44.40613288},{"x": 24, "y": 35.35337232}]

      a_double_cap_curve = [{"x": 1, "y": 30.25840207},{"x": 2, "y": 23.14704859},{"x": 3, "y": 11.20711744},{"x": 4, "y": 9.572826559},{"x": 5, "y": 8.002831386},{"x": 6, "y": 8.527914945},{"x": 7, "y": 11.81877328},{"x": 8, "y": 14.94534576},{"x": 9, "y": 18.20255552},{"x": 10, "y": 27.6716942},{"x": 11, "y": 30.72473142},{"x": 12, "y": 30.30561539},{"x": 13, "y": 22.3160758},{"x": 14, "y": 19.77014167},{"x": 15, "y": 19.90716533},{"x": 16, "y": 18.38930839},{"x": 17, "y": 19.14731038},{"x": 18, "y": 23.13955213},{"x": 19, "y": 38.15314637},{"x": 20, "y": 45.05624561},{"x": 21, "y": 44.28746062},{"x": 22, "y": 45.26575323},{"x": 23, "y": 46.8430575},{"x": 24, "y": 38.36845986}]

      b_double_cap_curve = [{"x": 1, "y": 30.25840207},{"x": 2, "y": 22.57902774},{"x": 3, "y": 8.743142276},{"x": 4, "y": 9.572826559},{"x": 5, "y": 8.002831386},{"x": 6, "y": 8.527914945},{"x": 7, "y": 13.14261765},{"x": 8, "y": 17.73626469},{"x": 9, "y": 21.23604798},{"x": 10, "y": 28.02183829},{"x": 11, "y": 26.47665179},{"x": 12, "y": 26.98649493},{"x": 13, "y": 22.3160758},{"x": 14, "y": 19.77014166},{"x": 15, "y": 19.90716533},{"x": 16, "y": 18.38930838},{"x": 17, "y": 19.14731038},{"x": 18, "y": 22.80061944},{"x": 19, "y": 31.24212727},{"x": 20, "y": 36.82281862},{"x": 21, "y": 41.3554775},{"x": 22, "y": 44.08328827},{"x": 23, "y": 47.67951668},{"x": 24, "y": 41.53417682}]

      a_2010_curve = filter_on_y_values a_2010_curve, @maximum_y
      b_2010_curve  = filter_on_y_values b_2010_curve, @maximum_y
      a_double_cap_curve  = filter_on_y_values a_double_cap_curve, @maximum_y
      b_double_cap_curve  = filter_on_y_values b_double_cap_curve, @maximum_y

      theData = [{color: "#00BFFF", values: a_2010_curve, label: "output_elements.import_export_capacity_chart.a_2010"}, {color: "#1947A8", values: b_2010_curve, label: "output_elements.import_export_capacity_chart.b_2010"}, {color: "#F5C400", values: a_double_cap_curve, label: "output_elements.import_export_capacity_chart.a_double"}, {color: "#DB2C18", values: b_double_cap_curve, label: "output_elements.import_export_capacity_chart.b_double"}]

      # Create SVG convas and set related variables
      [@width, @height] = @available_size()

      legend_columns = 2
      legend_rows = theData.length / legend_columns
      legend_column_width = @width/legend_columns
      legend_margin = 50
      cell_height = @legend_cell_height

      @series_height = @height - legend_margin

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
                             .text("#{I18n.t('output_elements.import_export_capacity_chart.x_label')}")
                             .attr("text-anchor","middle")

      yAxisLabel = yAxisGroup.append("text")
                             .attr("class","label")
                             .attr("x", 0 - (@series_height/2))
                             .attr("y", 0 - 25)
                             .text("#{I18n.t('output_elements.import_export_capacity_chart.y_label')}")
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
          .attr("transform", "translate(#{ @width - 100 },#{ @height - 90 }) rotate(-45)" )

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
