# This table is very different from the other ones, so the class has to
# override the render method
class @PlantProfitabilityTableView extends HtmlTableChartView
  initialize: ->
    @initialize_defaults()
    @gquery = gqueries.find_or_create_by_key 'dashboard_profitability'
    @app = App

  render: =>
    @clear_container()
    @container_node().html(@table_html())
    tmpl = _.template $('#merit-order-table-template').html()
    items = []
    for key, values of @gquery.future_value()
      profitability = if @app.settings.merit_order_enabled()
        values.profitability
      else
        'N/A'
      continue if values.capacity == 0

      items.push
        profitability: profitability
        key: key
        position: values.position
        capacity: values.capacity
        availability: values.availability
        full_load_hours: values.full_load_hours
        profit_per_mwh_electricity: values.profit_per_mwh_electricity
        label: @series_labels[key] || key

    for item, index in _.sortBy(items, (item) -> item.position)
      item.position = index + 1

    sorted_items = (forSet(item) for item in items.sort(@sorting_function))

    @container_node().html tmpl({series: sorted_items})
    @check_merit_enabled()
    true

  # Index used for sorting
  #
  profitability_index: (x) ->
    switch x.profitability
      when 'profitable' then 0
      when 'conditionally_profitable' then 1
      when 'unprofitable' then 2

  # This hash maps dispatchable keys to the chart series labels used by the
  # other merit order table
  #
  series_labels:
    energy_chp_combined_cycle_network_gas: 'central_gas_chp'
    energy_chp_engine_biogas: 'central_biogas_chp'
    energy_chp_ultra_supercritical_coal: 'coal_chp'
    energy_chp_ultra_supercritical_lignite: 'lignite_chp'
    energy_power_combined_cycle_ccs_coal: 'coal_igcc_ccs'
    energy_power_combined_cycle_ccs_network_gas: 'gas_ccgt_ccs'
    energy_power_combined_cycle_coal: 'coal_igcc'
    energy_power_combined_cycle_network_gas: 'gas_ccgt'
    energy_power_combined_cycle_hydrogen: 'hydrogen_ccgt'
    energy_power_engine_diesel: 'diesel_engine'
    energy_power_engine_network_gas: 'gas_engine'
    energy_power_nuclear_gen2_uranium_oxide: 'nuclear_ii'
    energy_power_nuclear_gen3_uranium_oxide: 'nuclear_iii'
    energy_power_supercritical_coal: 'coal_conv'
    energy_power_turbine_network_gas: 'gas_turbine'
    energy_power_turbine_hydrogen: 'hydrogen_turbine'
    energy_power_ultra_supercritical_ccs_coal: 'coal_pwd_ccs'
    energy_power_ultra_supercritical_coal: 'coal_pwd'
    energy_power_ultra_supercritical_cofiring_coal: 'coal_pwd_cofiring'
    energy_power_ultra_supercritical_crude_oil: 'oil_plant'
    energy_power_ultra_supercritical_lignite: 'lignite'
    energy_power_ultra_supercritical_network_gas: 'gas_conv',
    energy_chp_ultra_supercritical_cofiring_coal: 'coal_chp_cofiring'

  # Sort by two fields
  #
  sorting_function: (a,b) =>
    profitability_a = @profitability_index a
    profitability_b = @profitability_index b
    profits_a = a.profit_per_mwh_electricity
    profits_b = b.profit_per_mwh_electricity
    # sort by profitability (profitability < c.p < unprofitable)
    if profitability_a != profitability_b
      return -1 if profitability_a < profitability_b
      return  1 if profitability_a > profitability_b
    # sort by descending profits
    return -1 if profits_a > profits_b
    return  1 if profits_a < profits_b
    return  0
