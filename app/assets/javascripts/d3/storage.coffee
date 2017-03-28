D3.storage =
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

    draw: =>
      # Set maximum x and y values

      @maximum_x = 120
      @maximum_y = 400

      # Prepare chart data
      wind_curve = [{"x": 1.56952381, "y": 70.90246}, {"x": 6.278095238, "y": 70.9044288}, {"x": 10.98666667, "y": 72.29555201}, {"x": 12.71314286, "y": 74.43137059}, {"x": 12.87009524, "y": 74.67100086}, {"x": 13.02704762, "y": 74.91469534}, {"x": 13.184, "y": 75.16768124}, {"x": 13.34095238, "y": 75.42854033}, {"x": 13.49790476, "y": 75.69458527}, {"x": 13.65485714, "y": 75.96526663}, {"x": 13.81180952, "y": 76.23998936}, {"x": 13.9687619, "y": 76.51998749}, {"x": 14.12571429, "y": 76.80361321}, {"x": 15.6952381, "y": 79.81702756}, {"x": 20.40380952, "y": 89.66365542}, {"x": 25.11238095, "y": 99.85366402}, {"x": 29.82095238, "y": 110.2338363}, {"x": 34.52952381, "y": 120.7691442}, {"x": 39.23809524, "y": 131.3738578}, {"x": 43.94666667, "y": 142.028989}, {"x": 48.6552381, "y": 152.6992017}, {"x": 53.36380952, "y": 163.3381668}, {"x": 58.07238095, "y": 173.9616742}, {"x": 62.78095238, "y": 184.6014881}, {"x": 67.48952381, "y": 195.2763855}, {"x": 72.19809524, "y": 205.9753924}, {"x": 76.90666667, "y": 216.6792805}, {"x": 81.6152381, "y": 227.3839131}, {"x": 86.32380952, "y": 238.0994577}, {"x": 91.03238095, "y": 248.8330992}, {"x": 95.74095238, "y": 259.6064319}, {"x": 100.4495238, "y": 270.3844751}, {"x": 105.1580952, "y": 281.2033889}, {"x": 109.8666667, "y": 292.0645917}, {"x": 114.5752381, "y": 302.9514542}, {"x": 119.2838095, "y": 313.8640837}]

      p2p_curve = [{"x": 13.25, "y": 400}, {"x": 13.34095238, "y": 393.7561485}, {"x": 13.49790476, "y": 379.4174062}, {"x": 13.65485714, "y": 371.7928226}, {"x": 13.81180952, "y": 364.4300527}, {"x": 13.9687619, "y": 353.1869151}, {"x": 14.12571429, "y": 347.2701574}, {"x": 15.6952381, "y": 287.8361024}, {"x": 20.40380952, "y": 232.4817289}, {"x": 25.11238095, "y": 209.2050342}, {"x": 29.82095238, "y": 186.8281284}, {"x": 34.52952381, "y": 177.6260648}, {"x": 39.23809524, "y": 172.3356467}, {"x": 43.94666667, "y": 175.3061052}, {"x": 48.6552381, "y": 174.2811419}, {"x": 53.36380952, "y": 171.4759744}, {"x": 58.07238095, "y": 169.4988004}, {"x": 62.78095238, "y": 170.724686}, {"x": 67.48952381, "y": 170.5237917}, {"x": 72.19809524, "y": 169.8107129}, {"x": 76.90666667, "y": 170.4058393}, {"x": 81.6152381, "y": 171.5861178}, {"x": 86.32380952, "y": 173.248644}, {"x": 91.03238095, "y": 175.4240015}, {"x": 95.74095238, "y": 179.9837239}, {"x": 100.4495238, "y": 183.2655412}, {"x": 105.1580952, "y": 185.9943541}, {"x": 109.8666667, "y": 189.5222198}, {"x": 114.5752381, "y": 192.6192356}, {"x": 119.2838095, "y": 193.8362381}]

      p2g_curve = [{"x": 12.95, "y": 400}, {"x": 13.02704762, "y": 386.4038453}, {"x": 13.184, "y": 365.9592934}, {"x": 13.34095238, "y": 352.532753}, {"x": 13.49790476, "y": 340.3654101}, {"x": 13.65485714, "y": 329.8787997}, {"x": 13.81180952, "y": 320.6944241}, {"x": 13.9687619, "y": 310.0713722}, {"x": 14.12571429, "y": 302.8882829}, {"x": 15.6952381, "y": 243.8141291}, {"x": 20.40380952, "y": 168.2722571}, {"x": 25.11238095, "y": 136.1214371}, {"x": 29.82095238, "y": 114.6000968}, {"x": 34.52952381, "y": 101.998453}, {"x": 39.23809524, "y": 92.64334152}, {"x": 43.94666667, "y": 86.0685155}, {"x": 48.6552381, "y": 81.31521527}, {"x": 53.36380952, "y": 77.61854111}, {"x": 58.07238095, "y": 74.3162875}, {"x": 62.78095238, "y": 71.29800542}, {"x": 67.48952381, "y": 68.79792849}, {"x": 72.19809524, "y": 66.78708189}, {"x": 76.90666667, "y": 65.01075073}, {"x": 81.6152381, "y": 63.60188671}, {"x": 86.32380952, "y": 62.31165887}, {"x": 91.03238095, "y": 60.95353228}, {"x": 95.74095238, "y": 59.8918235}, {"x": 100.4495238, "y": 58.87546213}, {"x": 105.1580952, "y": 57.89314328}, {"x": 109.8666667, "y": 57.0470873}, {"x": 114.5752381, "y": 56.28451734}, {"x": 119.2838095, "y": 55.60800066}]

      p2h_curve = [{"x": 10.98666667, "y": 400}, {"x": 12.71314286, "y": 205.455858}, {"x": 12.87009524, "y": 197.1603587}, {"x": 13.02704762, "y": 190.6914147}, {"x": 13.184, "y": 180.6019692}, {"x": 13.34095238, "y": 173.9759327}, {"x": 13.49790476, "y": 167.9713138}, {"x": 13.65485714, "y": 162.7961413}, {"x": 13.81180952, "y": 158.2636254}, {"x": 13.9687619, "y": 153.0211185}, {"x": 14.12571429, "y": 149.4762432}, {"x": 15.6952381, "y": 120.3229776}, {"x": 20.40380952, "y": 83.04284531}, {"x": 25.11238095, "y": 67.17632274}, {"x": 29.82095238, "y": 56.55547905}, {"x": 34.52952381, "y": 50.33653144}, {"x": 39.23809524, "y": 45.71975686}, {"x": 43.94666667, "y": 42.47506121}, {"x": 48.6552381, "y": 40.1292938}, {"x": 53.36380952, "y": 38.30497442}, {"x": 58.07238095, "y": 36.67530272}, {"x": 62.78095238, "y": 35.18577178}, {"x": 67.48952381, "y": 33.95197659}, {"x": 72.19809524, "y": 32.95961798}, {"x": 76.90666667, "y": 32.08299342}, {"x": 81.6152381, "y": 31.38771495}, {"x": 86.32380952, "y": 30.75098379}, {"x": 91.03238095, "y": 30.08074439}, {"x": 95.74095238, "y": 29.55678803}, {"x": 100.4495238, "y": 29.05521076}, {"x": 105.1580952, "y": 28.57043357}, {"x": 109.8666667, "y": 28.1529025}, {"x": 114.5752381, "y": 27.77657202}, {"x": 119.2838095, "y": 27.44270908}]

      wind_curve = filter_on_y_values wind_curve, @maximum_y
      p2p_curve  = filter_on_y_values p2p_curve, @maximum_y
      p2g_curve  = filter_on_y_values p2g_curve, @maximum_y
      p2h_curve  = filter_on_y_values p2h_curve, @maximum_y

      theData = [{color: "#00BFFF", values: wind_curve, label: "output_elements.storage_chart.inland_wind"}, {color: "#F08080", values: p2p_curve, label: "output_elements.storage_chart.electricity_storage"}, {color: "green", values: p2g_curve, label: "output_elements.storage_chart.conversion_to_gas"}, {color: "#8B008B", values: p2h_curve, label: "output_elements.storage_chart.conversion_to_heat"}]

      # Prepare data for tracker line. Moved out of canvas if value exceeds maximum_x value.
      tracker_value = if @gquery.future_value() < @maximum_x then @gquery.future_value() else 2*@maximum_x

      tracker = [{"x": tracker_value, "y": 0}, {"x": tracker_value, "y": @maximum_y}]

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
                             .text("#{I18n.t('output_elements.storage_chart.installed_capacity')}")
                             .attr("text-anchor","middle")

      yAxisLabel = yAxisGroup.append("text")
                             .attr("class","label")
                             .attr("x", 0 - (@series_height/2))
                             .attr("y", 0 - 25)
                             .text("#{I18n.t('output_elements.storage_chart.total_cost')}")
                             .attr("text-anchor","middle")
                             .attr("transform", (d) -> "rotate(-90)" )

      lineFunction = d3.svg.line()
                           .x( (d) ->  xScale(d.x) )
                           .y( (d) ->  yScale(d.y) )
                           .interpolate("basis")

      # Draw lines, using data binding
      @svg.selectAll('path.serie')
          .data(theData)
          .enter()
          .append('path')
          .attr("d", (d) -> lineFunction(d.values) )
          .attr("stroke", (d) -> d.color )
          .attr("stroke-width", 3)
          .attr("fill", "none")

      # Draw tracker line
      @svg.append("path")
          .attr("id", "tracker")
          .style("stroke-dasharray", ("3, 3"))
          .attr("d", lineFunction(tracker))
          .attr("stroke", "red")
          .attr("stroke-width", 2)
          .attr("fill", "none")

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

      legendItem.selectAll('rect')
                .data(theData)
                .enter()
                .append('rect')
                .attr("x", (d,i) -> i%2 * legend_column_width )
                .attr("y", (d,i) -> Math.floor(i / 2) * cell_height )
                .attr("width", "10")
                .attr("height", "10")
                .attr("fill", (d) -> d.color )
      
      legendItem.append('line')
                .style("stroke-dasharray", ("3, 3"))
                .attr("x1", 0)
                .attr("y1", 2.5*cell_height)
                .attr("x2", 10)
                .attr("y2", 2.5*cell_height)
                .attr("stroke-width", 2)
                .attr("stroke", "#f00")
                .attr("fill", "none")

      legendItem.selectAll('text')
                .data(theData)
                .enter()
                .append('text')
                .attr("class", "legend_label")
                .attr("x", (d,i) -> i%2 * legend_column_width + 15 )
                .attr("y", (d,i) -> Math.floor(i / 2) * cell_height + 10 )
                .text((d) -> "#{I18n.t(d.label)}" )

      legendItem.append('text')
                .attr("class", "legend_label")
                .attr("x", 15)
                .attr("y", 2*cell_height + 10)
                .text("#{I18n.t('output_elements.storage_chart.tracker')}")

    refresh: =>
      # Prepare data for tracker line
      tracker_value = if @gquery.future_value() < @maximum_x then @gquery.future_value() else 200

      tracker = [{"x": tracker_value, "y": 0}, {"x": tracker_value, "y": @maximum_y}]

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

      # Update tracker line
      @svg.select("path#tracker")
          .transition()
          .duration(1000)
          .attr("d", lineFunction(tracker))