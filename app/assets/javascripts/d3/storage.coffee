D3.storage =
  View: class extends D3ChartView
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @gquery = gqueries.find_or_create_by_key('installed_capacity_solar_and_wind')
      
      # @gquery.on 'change', @doRefresh
      
    doRefresh: =>
      # console.log @gquery
      @render(true)

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
      [@width, @height] = @available_size()

      legend_columns = 2
      legend_rows = 4 / legend_columns
      legend_height = legend_rows * @legend_cell_height
      legend_margin = 50

      @series_height = @height - legend_height - legend_margin

      @svg = @create_svg_container @width, @height, @margins

      wind_curve = [{"x": 1.56952381, "y": 70.90246}, {"x": 6.278095238, "y": 70.9044288}, {"x": 10.98666667, "y": 72.29555201}, {"x": 12.71314286, "y": 74.43137059}, {"x": 12.87009524, "y": 74.67100086}, {"x": 13.02704762, "y": 74.91469534}, {"x": 13.184, "y": 75.16768124}, {"x": 13.34095238, "y": 75.42854033}, {"x": 13.49790476, "y": 75.69458527}, {"x": 13.65485714, "y": 75.96526663}, {"x": 13.81180952, "y": 76.23998936}, {"x": 13.9687619, "y": 76.51998749}, {"x": 14.12571429, "y": 76.80361321}, {"x": 15.6952381, "y": 79.81702756}, {"x": 20.40380952, "y": 89.66365542}, {"x": 25.11238095, "y": 99.85366402}, {"x": 29.82095238, "y": 110.2338363}, {"x": 34.52952381, "y": 120.7691442}, {"x": 39.23809524, "y": 131.3738578}, {"x": 43.94666667, "y": 142.028989}, {"x": 48.6552381, "y": 152.6992017}, {"x": 53.36380952, "y": 163.3381668}, {"x": 58.07238095, "y": 173.9616742}, {"x": 62.78095238, "y": 184.6014881}, {"x": 67.48952381, "y": 195.2763855}, {"x": 72.19809524, "y": 205.9753924}, {"x": 76.90666667, "y": 216.6792805}, {"x": 81.6152381, "y": 227.3839131}, {"x": 86.32380952, "y": 238.0994577}, {"x": 91.03238095, "y": 248.8330992}, {"x": 95.74095238, "y": 259.6064319}, {"x": 100.4495238, "y": 270.3844751}, {"x": 105.1580952, "y": 281.2033889}, {"x": 109.8666667, "y": 292.0645917}, {"x": 114.5752381, "y": 302.9514542}, {"x": 119.2838095, "y": 313.8640837}, {"x": 123.992381, "y": 324.7946744}, {"x": 128.7009524, "y": 335.7259938}, {"x": 133.4095238, "y": 346.6547876}, {"x": 138.1180952, "y": 357.5863384}, {"x": 142.8266667, "y": 368.5261048}, {"x": 147.5352381, "y": 379.4821049}, {"x": 152.2438095, "y": 390.4541543}, {"x": 156.952381, "y": 401.4240574}, {"x": 161.6609524, "y": 412.394985}, {"x": 166.3695238, "y": 423.3606601}, {"x": 171.0780952, "y": 434.3212688}, {"x": 175.7866667, "y": 445.2781442}, {"x": 180.4952381, "y": 456.2298559}, {"x": 185.2038095, "y": 467.186163}, {"x": 189.912381, "y": 478.146113}]

      p2p_curve = [{"x": 13.25, "y": 400}, {"x": 13.34095238, "y": 393.7561485}, {"x": 13.49790476, "y": 379.4174062}, {"x": 13.65485714, "y": 371.7928226}, {"x": 13.81180952, "y": 364.4300527}, {"x": 13.9687619, "y": 353.1869151}, {"x": 14.12571429, "y": 347.2701574}, {"x": 15.6952381, "y": 287.8361024}, {"x": 20.40380952, "y": 232.4817289}, {"x": 25.11238095, "y": 209.2050342}, {"x": 29.82095238, "y": 186.8281284}, {"x": 34.52952381, "y": 177.6260648}, {"x": 39.23809524, "y": 172.3356467}, {"x": 43.94666667, "y": 175.3061052}, {"x": 48.6552381, "y": 174.2811419}, {"x": 53.36380952, "y": 171.4759744}, {"x": 58.07238095, "y": 169.4988004}, {"x": 62.78095238, "y": 170.724686}, {"x": 67.48952381, "y": 170.5237917}, {"x": 72.19809524, "y": 169.8107129}, {"x": 76.90666667, "y": 170.4058393}, {"x": 81.6152381, "y": 171.5861178}, {"x": 86.32380952, "y": 173.248644}, {"x": 91.03238095, "y": 175.4240015}, {"x": 95.74095238, "y": 179.9837239}, {"x": 100.4495238, "y": 183.2655412}, {"x": 105.1580952, "y": 185.9943541}, {"x": 109.8666667, "y": 189.5222198}, {"x": 114.5752381, "y": 192.6192356}, {"x": 119.2838095, "y": 193.8362381}, {"x": 123.992381, "y": 195.6567182}, {"x": 128.7009524, "y": 198.8414522}, {"x": 133.4095238, "y": 201.4850583}, {"x": 138.1180952, "y": 204.4295024}, {"x": 142.8266667, "y": 208.266156}, {"x": 147.5352381, "y": 210.4265564}, {"x": 152.2438095, "y": 213.9123489}, {"x": 156.952381, "y": 216.5214692}, {"x": 161.6609524, "y": 219.446682}, {"x": 166.3695238, "y": 221.2113635}, {"x": 171.0780952, "y": 226.1135357}, {"x": 175.7866667, "y": 229.1515339}, {"x": 180.4952381, "y": 232.5167125}, {"x": 185.2038095, "y": 235.9302273}, {"x": 189.912381, "y": 240.3548621}]

      p2g_curve = [{"x": 12.95, "y": 400}, {"x": 13.02704762, "y": 386.4038453}, {"x": 13.184, "y": 365.9592934}, {"x": 13.34095238, "y": 352.532753}, {"x": 13.49790476, "y": 340.3654101}, {"x": 13.65485714, "y": 329.8787997}, {"x": 13.81180952, "y": 320.6944241}, {"x": 13.9687619, "y": 310.0713722}, {"x": 14.12571429, "y": 302.8882829}, {"x": 15.6952381, "y": 243.8141291}, {"x": 20.40380952, "y": 168.2722571}, {"x": 25.11238095, "y": 136.1214371}, {"x": 29.82095238, "y": 114.6000968}, {"x": 34.52952381, "y": 101.998453}, {"x": 39.23809524, "y": 92.64334152}, {"x": 43.94666667, "y": 86.0685155}, {"x": 48.6552381, "y": 81.31521527}, {"x": 53.36380952, "y": 77.61854111}, {"x": 58.07238095, "y": 74.3162875}, {"x": 62.78095238, "y": 71.29800542}, {"x": 67.48952381, "y": 68.79792849}, {"x": 72.19809524, "y": 66.78708189}, {"x": 76.90666667, "y": 65.01075073}, {"x": 81.6152381, "y": 63.60188671}, {"x": 86.32380952, "y": 62.31165887}, {"x": 91.03238095, "y": 60.95353228}, {"x": 95.74095238, "y": 59.8918235}, {"x": 100.4495238, "y": 58.87546213}, {"x": 105.1580952, "y": 57.89314328}, {"x": 109.8666667, "y": 57.0470873}, {"x": 114.5752381, "y": 56.28451734}, {"x": 119.2838095, "y": 55.60800066}, {"x": 123.992381, "y": 55.11726967}, {"x": 128.7009524, "y": 54.65903099}, {"x": 133.4095238, "y": 54.23973317}, {"x": 138.1180952, "y": 53.78818953}, {"x": 142.8266667, "y": 53.38867515}, {"x": 147.5352381, "y": 52.98208914}, {"x": 152.2438095, "y": 52.61018061}, {"x": 156.952381, "y": 52.35293608}, {"x": 161.6609524, "y": 52.07647533}, {"x": 166.3695238, "y": 51.84592093}, {"x": 171.0780952, "y": 51.60318321}, {"x": 175.7866667, "y": 51.41908843}, {"x": 180.4952381, "y": 51.19321325}, {"x": 185.2038095, "y": 50.96454732}, {"x": 189.912381, "y": 50.77121209}]

      p2h_curve = [{"x": 10.98666667, "y": 400}, {"x": 12.71314286, "y": 228.7764113}, {"x": 12.87009524, "y": 222.3627311}, {"x": 13.02704762, "y": 215.0889505}, {"x": 13.184, "y": 204.9478083}, {"x": 13.34095238, "y": 197.9715313}, {"x": 13.49790476, "y": 191.1411786}, {"x": 13.65485714, "y": 185.7849815}, {"x": 13.81180952, "y": 181.1985766}, {"x": 13.9687619, "y": 175.0761945}, {"x": 14.12571429, "y": 171.5865541}, {"x": 15.6952381, "y": 139.8789597}, {"x": 20.40380952, "y": 100.7626762}, {"x": 25.11238095, "y": 83.44912552}, {"x": 29.82095238, "y": 71.61168192}, {"x": 34.52952381, "y": 64.87122369}, {"x": 39.23809524, "y": 59.75893802}, {"x": 43.94666667, "y": 56.5253776}, {"x": 48.6552381, "y": 53.92616707}, {"x": 53.36380952, "y": 51.70829485}, {"x": 58.07238095, "y": 49.83739032}, {"x": 62.78095238, "y": 48.36430919}, {"x": 67.48952381, "y": 47.03305588}, {"x": 72.19809524, "y": 45.96230998}, {"x": 76.90666667, "y": 44.98052137}, {"x": 81.6152381, "y": 44.24208102}, {"x": 86.32380952, "y": 43.57563066}, {"x": 91.03238095, "y": 42.90636489}, {"x": 95.74095238, "y": 42.43958471}, {"x": 100.4495238, "y": 41.96311333}, {"x": 105.1580952, "y": 41.44889278}, {"x": 109.8666667, "y": 41.02473796}, {"x": 114.5752381, "y": 40.65863877}, {"x": 119.2838095, "y": 40.31063025}, {"x": 123.992381, "y": 40.08080147}, {"x": 128.7009524, "y": 39.89120164}, {"x": 133.4095238, "y": 39.71075389}, {"x": 138.1180952, "y": 39.50368587}, {"x": 142.8266667, "y": 39.29896602}, {"x": 147.5352381, "y": 39.11820061}, {"x": 152.2438095, "y": 38.92447381}, {"x": 156.952381, "y": 38.79985531}, {"x": 161.6609524, "y": 38.65004071}, {"x": 166.3695238, "y": 38.54853293}, {"x": 171.0780952, "y": 38.4922858}, {"x": 175.7866667, "y": 38.43552252}, {"x": 180.4952381, "y": 38.34970162}, {"x": 185.2038095, "y": 38.26120688}, {"x": 189.912381, "y": 38.2226129}]

      #Width and height
      maximum_x = 190
      maximum_y = 400
      tracker_value = if @gquery.future_value() < maximum_x then @gquery.future_value() else 200

      wind_curve  = filter_on_y_values wind_curve, maximum_y
      p2p_curve = filter_on_y_values p2p_curve, maximum_y
      p2g_curve = filter_on_y_values p2g_curve, maximum_y
      p2h_curve = filter_on_y_values p2h_curve, maximum_y

      tracker = [{"x": tracker_value, "y": 0}, {"x": tracker_value, "y": maximum_y}];

      dataset = wind_curve.concat(p2p_curve,p2g_curve,p2h_curve);

      max_x = d3.max(dataset, (d) -> d.x )
      max_y = d3.max(dataset, (d) -> d.y )

      #Create scale functions
      xScale = d3.scale.linear()
              .domain([0, maximum_x])
              .range([0, @width])

      yScale = d3.scale.linear()
              .domain([0, maximum_y])
              .range([@series_height, 0])

      #Create SVG element
      svgContainer = @svg

      #Create X axis
      xAxis = d3.svg.axis()
                      .scale(xScale)
                      .orient("bottom")
                      # .ticks(5)
      
      #Define Y axis
      yAxis = d3.svg.axis()
                    .scale(yScale)
                    .orient("left")
                    .tickValues([])
                    .tickSize(0)
      
      #Create xAxis
      xAxisGroup = @svg.append("g")
                                 .attr("class", "x_axis")
                                 .attr("transform", "translate(0,#{@series_height})")
                                 .call(xAxis)
      
      #Create Y axis
      yAxisGroup = @svg.append("g")
                                 .attr("class", "y_axis")
                                 .attr("transform", "translate(0,0)")
                                 .call(yAxis)
      
      xAxisLabel = xAxisGroup.append("text")
                               .attr("class","label")
                               .attr("x", @width/2)
                               .attr("y", 35)
                               .text("Installed capacity of wind & solar, GW")
                               .attr("text-anchor","middle")
      
      yAxisLabel = yAxisGroup.append("text")
                               .attr("class","label")
                               .attr("x", 0 - (@series_height/2))
                               .attr("y", 0 - 25)
                               .text("Total cost of integrated production, €/MWh")
                               .attr("text-anchor","middle")
                               .attr("transform", (d) -> "rotate(-90)" )
      
      #This is the accessor function we talked about above
      lineFunction = d3.svg.line()
                             .x( (d) ->  xScale(d.x) )
                             .y( (d) ->  yScale(d.y) )
                             .interpolate("basis")
      
      #The line SVG Path we draw
      @svg.append("path")
               .attr("d", lineFunction(wind_curve))
               .attr("stroke", "#00BFFF")
               .attr("stroke-width", 3)
               .attr("fill", "none")
      
      @svg.append("path")
               .attr("d", lineFunction(p2p_curve))
               .attr("stroke", "#F08080")
               .attr("stroke-width", 3)
               .attr("fill", "none")
      
      @svg.append("path")
               .attr("d", lineFunction(p2g_curve))
               .attr("stroke", "green")
               .attr("stroke-width", 3)
               .attr("fill", "none")
      
      @svg.append("path")
               .attr("d", lineFunction(p2h_curve))
               .attr("stroke", "#8B008B")
               .attr("stroke-width", 3)
               .attr("fill", "none")
      
      @svg.append("path")
               .style("stroke-dasharray", ("3, 3"))
               .attr("d", lineFunction(tracker))
               .attr("stroke", "red")
               .attr("stroke-width", 2)
               .attr("fill", "none")
      
      @svg.append("g").append("text")
               .attr("class", "indicative_label")
               .attr("x", 320)
               .attr('y', 0 - 300)
               .text("INDICATIVE")
               .attr("transform", (d) -> "rotate(45)" )
      
      legendGroup = @svg.append("g")
                         .attr("class", "legend")
                         .attr("transform", "translate(0,#{@series_height + legend_margin})")
      
      legendItem = legendGroup.append("svg")
      
      legendItem.append("rect")
               .attr("x", 0)
               .attr("y", 0)
               .attr("width", "10")
               .attr("height", "10")
               .attr("fill", "#00BFFF")
      
      legendItem.append("text")
               .attr("class", "legend_label")
               .attr("x", 15)
               .attr("y", 10)
               .text("Inland wind turbine")
      
      legendItem.append("rect")
               .attr("x", @width/2)
               .attr("y", 0)
               .attr("width", "10")
               .attr("height", "10")
               .attr("fill", "#F08080")
      
      legendItem.append("text")
               .attr("class", "legend_label")
               .attr("x", @width/2 + 15)
               .attr("y", 10)
               .text("Electricity Storage")
      
      legendItem.append("rect")
               .attr("x", 0)
               .attr("y", 15)
               .attr("width", "10")
               .attr("height", "10")
               .attr("fill", "green")
      
      legendItem.append("text")
               .attr("class", "legend_label")
               .attr("x", 15)
               .attr("y", 25)
               .text("Conversion to Gas")
      
      legendItem.append("rect")
               .attr("x", @width/2)
               .attr("y", 15)
               .attr("width", "10")
               .attr("height", "10")
               .attr("fill", "#8B008B")
      
      legendItem.append("text")
               .attr("class", "legend_label")
               .attr("x", @width/2 + 15)
               .attr("y", 25)
               .text("Conversion to Heat")

    refresh: =>
      #Empty function