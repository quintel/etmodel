D3.co2_emissions_biomass =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @series = @model.series.models

    gquery_keys:
      start:          '1990_in_co2_emissions'
      domestic:       'co2_emissions_of_final_demand_excluding_imported_' +
                      'electricity_in_co2_emissions'
      imported:       'co2_emissions_of_imported_electricity_in_co2_emissions'
      gas_present:    'climate_relevant_co2_biomass_gas_present'
      gas_future:     'climate_relevant_co2_biomass_gas_future'
      liquid_present: 'climate_relevant_co2_biomass_liquid_present'
      liquid_future:  'climate_relevant_co2_biomass_liquid_future'
      solid_present:  'climate_relevant_co2_biomass_solid_present'
      solid_future:   'climate_relevant_co2_biomass_solid_future'
      target:         'policy_goal_co2_emissions_target_value'

    can_be_shown_as_table: -> true

    margins:
      top: 20
      bottom: 45
      left: 30
      right: 40

    # This method is called right before rendering because the series are
    # added when the JSON request is complete, ie after the initialize method
    #
    setup_series: =>
      @serie_1990           = @serie_for(@gquery_keys.start)
      @serie_domestic       = @serie_for(@gquery_keys.domestic)
      @serie_imported       = @serie_for(@gquery_keys.imported)
      @serie_gas_present    = @serie_for(@gquery_keys.gas_present)
      @serie_gas_future     = @serie_for(@gquery_keys.gas_future)
      @serie_liquid_present = @serie_for(@gquery_keys.liquid_present)
      @serie_liquid_future  = @serie_for(@gquery_keys.liquid_future)
      @serie_solid_present  = @serie_for(@gquery_keys.solid_present)
      @serie_solid_future   = @serie_for(@gquery_keys.solid_future)
      @serie_target         = @serie_for(@gquery_keys.target)

    draw: =>
      @setup_series()

      [@width, @height] = @available_size()

      legend_height = @legend_cell_height
      legend_margin = 20
      @series_height = @height - legend_height - legend_margin

      @svg = @create_svg_container @width, @height, @margins

      # Ugly stuff. Check the db to see which series have been defined.
      # Since this chart is very specific the series could actually be
      # hard-coded
      series_for_legend = [
        @serie_1990, 
        @serie_gas_present,
        @serie_domestic,
        @serie_liquid_present,
        @serie_imported,
        @serie_solid_present,
        @serie_target
      ]

      @draw_legend
        svg: @svg
        series: series_for_legend
        width: @width
        vertical_offset: @series_height + legend_margin
        columns: 2

      @x = d3.scale.ordinal().rangeRoundBands([0, @width - 25])
        .domain([1990, @start_year, @end_year])
      @x_axis = d3.svg.axis()
        .scale(@x)
        .tickSize(2, 2, 0)
        .orient("bottom")
      @svg.append("svg:g")
        .attr("class", "x_axis inner_grid")
        .attr("transform", "translate(0, #{@series_height})")
        .call(@x_axis)

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 1])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 1])

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(5)
        .tickSize(-(@width - 25), 10, 0)
        .orient("right")
        .tickFormat(@main_formatter())
      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@width - 25}, 0)")
        .call(@y_axis)

      # there we go
      @block_width = @x.rangeBand() * 0.5
      rect = @svg.selectAll('rect.serie')
        .data(@prepare_data(), (s) -> s.id)
        .enter().append('svg:rect')
        .attr('class', 'serie')
        .attr("width", @block_width)
        .attr('x', (s) => @x(s.x) + @block_width / 2)
        .attr('y', @series_height)
        .style('fill', (d) => d.color)
        .style('opacity', 0.8)

      $("#{@container_selector()} rect.serie").qtip
        content: -> $(this).attr('data-tooltip')
        position:
          my: 'bottom center'
          at: 'top center'

      # target lines
      @svg.selectAll('rect.target_line')
        .data([@serie_target], (d) -> d.get 'gquery_key')
        .enter()
        .append('svg:rect')
        .attr('class', 'target_line')
        .style('fill', '#ff0000')
        .attr('height', 2)
        .attr('width', @block_width * 1.2)
        .attr('x', @x(@end_year) + @block_width * 0.4)
        .attr('y', @series_height)
        .style('opacity', 0.0)

    max_series_value: ->
      _.max([
        @serie_1990.safe_future_value(),
        @serie_domestic.safe_present_value() +
          @serie_imported.safe_present_value() +
          @serie_gas_present.safe_present_value() +
          @serie_liquid_present.safe_present_value() +
          @serie_solid_present.safe_present_value(),
        @serie_domestic.safe_future_value() +
          @serie_imported.safe_future_value() +
          @serie_gas_future.safe_future_value() +
          @serie_liquid_future.safe_future_value() +
          @serie_solid_future.safe_future_value()
      ])

    refresh: =>
      # calculate tallest column
      tallest = @max_series_value()

      # update the scales as needed
      @y = @y.domain([0, tallest])
      @inverted_y = @inverted_y.domain([0, tallest])

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      # let the stack method filter the data again, adding the offsets as needed
      @svg.selectAll('rect.serie')
        .data(@prepare_data(), (s) -> s.id)
        .transition()
        .attr('y', (d) => @series_height - @y((d.y0 || 0.0) + d.y))
        .attr('height', (d) => @y(d.y))
        .attr("data-tooltip", (d) => @main_formatter()(d.y))

      # move the target lines
      @svg.selectAll('rect.target_line')
        .data([@serie_target], (d) -> d.get 'gquery_key')
        .transition()
        .attr('y', (d) => @series_height - (@y d.safe_future_value()))
        .style('opacity', (d) -> if d.future_value() == null then 0.0 else 0.8)


    prepare_data: =>
      stack = d3.layout.stack().offset('zero')

      target = {
        id:    'co2_1990',
        x:     1990,
        y:     @serie_1990.safe_future_value(),
        color: @serie_1990.get('color'),
        label: @serie_1990.get('label')
      }

      stacked = _.flatten(stack([[{
        id:   'co2_present_domestic',
        x:     @start_year,
        y:     @serie_domestic.safe_present_value(),
        color: @serie_domestic.get('color'),
        label: @serie_domestic.get('label')
      }, {
        id:   'co2_future_domestic',
        x:     @end_year,
        y:     @serie_domestic.safe_future_value(),
        color: @serie_domestic.get('color'),
        label: @serie_domestic.get('label')
      }], [{
        id:    'co2_present_imported',
        x:     @start_year,
        y:     @serie_imported.safe_present_value(),
        color: @serie_imported.get('color'),
        label: @serie_imported.get('label')
      }, {
        id:    'co2_future_imported',
        x:     @end_year,
        y:     @serie_imported.safe_future_value(),
        color: @serie_imported.get('color'),
        label: @serie_imported.get('label')
      }], [{
        id:    'co2_present_gas',
        x:     @start_year,
        y:     @serie_gas_present.safe_present_value(),
        color: @serie_gas_present.get('color'),
        label: @serie_gas_present.get('label')
      }, {
        id:    'co2_future_gas',
        x:     @end_year,
        y:     @serie_gas_future.safe_future_value(),
        color: @serie_gas_future.get('color'),
        label: @serie_gas_future.get('label')
      }], [{
        id:    'co2_present_liquid',
        x:     @start_year,
        y:     @serie_liquid_present.safe_present_value(),
        color: @serie_liquid_present.get('color'),
        label: @serie_liquid_present.get('label')
      }, {
        id:    'co2_future_liquid',
        x:     @end_year,
        y:     @serie_liquid_future.safe_future_value(),
        color: @serie_liquid_future.get('color'),
        label: @serie_liquid_future.get('label')
      }], [{
        id:    'co2_present_solid',
        x:     @start_year,
        y:     @serie_solid_present.safe_present_value(),
        color: @serie_solid_present.get('color'),
        label: @serie_solid_present.get('label')
      }, {
        id:    'co2_future_solid',
        x:     @end_year,
        y:     @serie_solid_future.safe_future_value(),
        color: @serie_solid_future.get('color'),
        label: @serie_solid_future.get('label')
      }]]))

      [target, stacked...]

    serie_for: (gquery_key) =>
      _.detect(@series, (s) -> s.get('gquery_key') == gquery_key)

    # This chart has to override the standard render_as_table method
    #
    render_as_table: =>
      # return false
      @clear_container()
      @setup_series()

      formatter = @main_formatter(precision: 4)

      unit = @model.get('unit')
      raw_target = @serie_target.future_value()
      target = if raw_target?
        target = formatter(raw_target)
      else
        '-'
      html = "
        <table class='chart has-total autostripe'>
          <thead>
            <tr>
              <td></td>
              <th>1990</td>
              <th>#{@start_year}</td>
              <th>#{@end_year}</td>
              <th>#{I18n.t('output_element_series.target')}</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>#{I18n.t('output_element_series.co2_emissions_1990')}</th>
              <td>#{formatter(@serie_1990.safe_present_value())}<br/></td>
              <td class='novalue'>&mdash;</td>
              <td class='novalue'>&mdash;</td>
              <td class='novalue'>&mdash;</td>
            </tr>
            
            <tr>
              <th>#{I18n.t('output_element_series.co2_emission_local_production')}</th>
              <td class='novalue'>&mdash;</td>
              <td>#{formatter(@serie_domestic.safe_present_value())}<br/></td>
              <td>#{formatter(@serie_domestic.safe_future_value())}</td>
              <td class='novalue'>&mdash;</td>
            </tr>

            <tr>
              <th>#{I18n.t('output_element_series.co2_emission_imported_electricity')}</th>
              <td class='novalue'>&mdash;</td>
              <td>#{formatter(@serie_imported.safe_present_value())}<br/></td>
              <td>#{formatter(@serie_imported.safe_future_value())}</td>
              <td class='novalue'>&mdash;</td>
            </tr>

            <tr>
              <th>#{I18n.t('output_element_series.co2_biomass_gas_present')}</th>
              <td class='novalue'>&mdash;</td>
              <td>#{formatter(@serie_gas_present.safe_present_value())}<br/></td>
              <td>#{formatter(@serie_gas_future.safe_future_value())}</td>
              <td class='novalue'>&mdash;</td>
            </tr>

            <tr>
              <th>#{I18n.t('output_element_series.co2_biomass_liquid_present')}</th>
              <td class='novalue'>&mdash;</td>
              <td>#{formatter(@serie_liquid_present.safe_present_value())}<br/></td>
              <td>#{formatter(@serie_liquid_future.safe_future_value())}</td>
              <td class='novalue'>&mdash;</td>
            </tr>

            <tr>
              <th>#{I18n.t('output_element_series.co2_biomass_solid_present')}</th>
              <td class='novalue'>&mdash;</td>
              <td>#{formatter(@serie_solid_present.safe_present_value())}<br/></td>
              <td>#{formatter(@serie_solid_future.safe_future_value())}</td>
              <td class='novalue'>&mdash;</td>
            </tr>
          </tbody>
          <tfoot>
            <tr>
              <th>#{I18n.t('output_element_series.total')}</th>
              <td>#{formatter(@serie_1990.safe_future_value())}</td>
              <td>#{formatter(@serie_domestic.safe_present_value() + 
                                @serie_imported.safe_present_value() +
                                @serie_gas_present.safe_present_value() +
                                @serie_liquid_present.safe_present_value() +
                                @serie_solid_present.safe_present_value())}<br/></td>
              <td>#{formatter(@serie_domestic.safe_future_value() + 
                                @serie_imported.safe_future_value() +
                                @serie_gas_future.safe_future_value() +
                                @serie_liquid_future.safe_future_value() +
                                @serie_solid_future.safe_future_value())}</td>
              <td>#{target}</td>
            </tr>
          </tfoot>
        </table>
      "
      @container_node().html(html)
