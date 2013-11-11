D3.import_export_flows =
  View: class extends D3ChartView
    initialize: ->
      D3ChartView.prototype.initialize.call(this)

    can_be_shown_as_table: -> false

    margins:
      top: 20
      bottom: 20
      left: 20
      right: 30

    r_1 = (data) ->
      parseInt($('circle[cx="' + data.x1 + '"][cy="' + data.y1 + '"]').attr('r')) + 10

    r_2 = (data) ->
      parseInt($('circle[cx="' + data.x2 + '"][cy="' + data.y2 + '"]').attr('r')) + 10

    adjust_coordinates = (data) ->
      r1 = r_1(data)
      r2 = r_2(data)
      ratio = Math.abs(data.y1 - data.y2)/ Math.abs(data.x1 - data.x2)
      delta_x1 = Math.sqrt(Math.pow(r1,2)/ (1 + Math.pow(ratio,2)))
      delta_y1 = ratio*delta_x1
      delta_x2 = Math.sqrt(Math.pow(r2,2)/ (1 + Math.pow(ratio,2)))
      delta_y2 = ratio*delta_x2
    
      if (data.x1 > data.x2 && data.y1 < data.y2)
        adjusted_x1 = Math.round(data.x1 - delta_x1)
        adjusted_y1 = Math.round(data.y1 + delta_y1)
        adjusted_x2 = Math.round(data.x2 + delta_x2)
        adjusted_y2 = Math.round(data.y2 - delta_y2)
      else if (data.x1 < data.x2 && data.y1 > data.y2)
        adjusted_x1 = Math.round(data.x1 + delta_x1)
        adjusted_y1 = Math.round(data.y1 - delta_y1)
        adjusted_x2 = Math.round(data.x2 - delta_x2)
        adjusted_y2 = Math.round(data.y2 + delta_y2)
      else if (data.x1 < data.x2 && data.y1 < data.y2)
        adjusted_x1 = Math.round(data.x1 + delta_x1)
        adjusted_y1 = Math.round(data.y1 + delta_y1)
        adjusted_x2 = Math.round(data.x2 - delta_x2)
        adjusted_y2 = Math.round(data.y2 - delta_y2)
      else if (data.x1 == data.x2)
        adjusted_x1 = Math.round(data.x1)
        adjusted_x2 = Math.round(data.x2)
        if (data.y1 < data.y2)
          adjusted_y1 = Math.round(data.y1 + r1)
          adjusted_y2 = Math.round(data.y2 - r2)
        else
          adjusted_y1 = Math.round(data.y1 - r1)
          adjusted_y2 = Math.round(data.y2 + r2)
      else if (data.y1 == data.y2)
        adjusted_y1 = Math.round(data.y1)
        adjusted_y2 = Math.round(data.y2)
        if (data.x1 < data.x2)
          adjusted_x1 = Math.round(data.x1 + r1)
          adjusted_x2 = Math.round(data.x2 - r2)
        else
          adjusted_x1 = Math.round(data.x1 - r1)
          adjusted_x2 = Math.round(data.x2 + r2)
      else
        adjusted_x1 = data.x1
        adjusted_y1 = data.y1
        adjusted_x2 = data.x2
        adjusted_y2 = data.y2

      return {'x1': adjusted_x1, 'y1': adjusted_y1, 'x2': adjusted_x2, 'y2': adjusted_y2}

    get_connection_coordinates = (data) ->
      x1 = parseInt($('circle[id="' + data.from + '"]').attr('cx'))
      y1 = parseInt($('circle[id="' + data.from + '"]').attr('cy'))
      x2 = parseInt($('circle[id="' + data.to + '"]').attr('cx'))
      y2 = parseInt($('circle[id="' + data.to + '"]').attr('cy'))
      return {'x1': x1, 'y1': y1, 'x2': x2, 'y2': y2}

    create_connections_data = (data) ->
      connection_data = []
      for i in [0...data.length]
        coordinates = get_connection_coordinates(data[i])
        connection_data[i] = {'x1': coordinates.x1, 'y1': coordinates.y1, 'x2': coordinates.x2, 'y2': coordinates.y2, 'capacity': data[i].capacity, 'direction': data[i].direction}
      return connection_data

    label_coordinates = (data) ->
      x = Math.abs(adjust_coordinates(data).x1 - adjust_coordinates(data).x2)
      y = Math.abs(adjust_coordinates(data).y1 - adjust_coordinates(data).y2)
      if (data.direction == 2)
        dx = Math.sqrt(Math.pow(x,2) + Math.pow(y,2))/ 2
      else
        dx = 18

      return {'x': x, 'y': y, 'dx': dx}

    draw: =>
      [@width, @height] = @available_size()

      country_data = [{'country': 'NL', 'x': 275, 'y': 25, 'r': 25},
                      {'country': 'BE', 'x': 165, 'y': 140, 'r': 20},
                      {'country': 'FR', 'x': 25, 'y': 295, 'r': 30},
                      {'country': 'DE', 'x': 500, 'y': 150, 'r': 30}]

      conn_data = [{'from': 'BE', 'to': 'NL', 'capacity': '2300 MW', 'direction': 2},{'from': 'NL', 'to': 'DE', 'capacity': '5740 MW', 'direction': 2},
                      {'from': 'BE', 'to': 'FR', 'capacity': '2300 MW', 'direction': 1},
                      {'from': 'FR', 'to': 'BE', 'capacity': '3200 MW', 'direction': 1},{'from': 'FR', 'to': 'DE', 'capacity': '2750 MW', 'direction': 2}]

      svg = @create_svg_container @width, @height, @margins

      svg.append("defs").append("marker")
          .attr("id", "arrowhead")
          .attr("refX", 4)
          .attr("refY", 2)
          .attr("markerWidth", 6)
          .attr("markerHeight", 4)
          .attr("orient", "auto")
          .append("path")
          .attr("d", "M 0,0 V 4 L6,2 Z")

      svg.select('defs').append("marker")
          .attr("id", "reverse-arrowhead")
          .attr("refX", 2)
          .attr("refY", 2)
          .attr("markerWidth", 6)
          .attr("markerHeight", 4)
          .attr("orient", 'auto')
          .append("path")
          .attr("d", "M 0 2 L 6 0 L 6 4 Z")

      countries = svg.append('g')

      countries.selectAll('circle')
                .data(country_data)
                .enter()
                .append('circle')
                .attr(
                  id: (d) -> d.country,
                  cx: (d) -> d.x,
                  cy: (d) -> d.y,
                  r: (d) -> d.r,
                  fill: 'rgba(180,180,180,1)',
                  class: 'country'
                )

      countries.selectAll('text')
                .data(country_data)
                .enter()
                .append('text')
                .text((d) -> d.country)
                .attr(
                  x: (d) -> d.x,
                  y: (d) -> d.y + 6,
                  'text-anchor': 'middle',
                  fill: '#fff'
                  class: 'country_label'
                )

      connections = svg.append('g')

      connections.selectAll('path')
                  .data(create_connections_data(conn_data))
                  .enter()
                  .append('path')
                  .attr(
                    id: (d,i) -> "edge_" + i,
                    d: (d) -> coord = adjust_coordinates(d); return "M" + coord.x1 + "," + coord.y1 + " L" + coord.x2 + "," + coord.y2,
                    # stroke: 'rgb(255,0,0)',
                    'stroke-width': 4,
                    'marker-start': (d) -> if (d.direction == 2) then "url(#reverse-arrowhead)" else "",
                    "marker-end": "url(#arrowhead)"
                  )

      connections.selectAll('text')
                  .data(create_connections_data(conn_data))
                  .enter()
                  .append('text')
                  .attr(
                    dx: (d) -> label_coordinates(d).dx,
                    dy: (d) -> -5,
                    class: 'connection_label'
                  )
                  .append('textPath')
                  .text((d) -> d.capacity)
                  .attr(
                    'text-anchor': (d) -> if (d.direction == 2) then 'middle' else 'left',
                    'xlink:href': (d,i) -> '#edge_' + i
                  )

    refresh: =>
      