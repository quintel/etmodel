class @MeritOrder
  constructor: (app) ->
    @app = app
    @gquery = gqueries.find_or_create_by_key 'dashboard_merit_order'

  dashboard_value: =>
    return null unless @app.settings.merit_order_enabled()
    q = @gquery.future_value()
    profitables = _.select(_.values(q), (v) -> v.profitable == 'profitable' ).length
    tot = _.keys(q).length
    profitables/tot

  format_table: =>
    tmpl = _.template $('#merit-order-table-template').html()
    items = []
    for key, values of @gquery.future_value()
      value = if @app.settings.merit_order_enabled()
        values.profitable
      else
        'N/A'
      continue if values.capacity == 0
      items.push
        profitable: value
        key: key
        position: values.position
        capacity: values.capacity
        full_load_hours: values.full_load_hours
        profits: values.profits
        label: @series_labels[key] || key


    sorted_items = items.sort(@sorting_function)

    data = {series: sorted_items}

    $('#merit-order-table').html tmpl(data)
    true

  sorting_function: (a,b) =>
    pa = @profitability_index a
    pb = @profitability_index b
    ca = a.profits
    cb = b.profits
    # sort by profitability (profitability < c.p < unprofitable)
    if pa != pb
      return -1 if pa < pb
      return 1 if pa > pb
      return 0
    # sort by descending profits
    return -1 if ca > cb
    return 1 if ca < cb
    return 0

  profitability_index: (x) ->
    switch x.profitable
      when 'profitable' then 0
      when 'conditionally_profitable' then 1
      when 'unprofitable' then 2

  series_labels:
    energy_chp_combined_cycle_network_gas: 'central_gas_chp'
    energy_chp_ultra_supercritical_coal: 'coal_chp'
    energy_chp_ultra_supercritical_wood_pellets: 'wood_pellets_chp'
    energy_chp_ultra_supercritical_crude_oil: 'oil_chp'
    energy_power_combined_cycle_ccs_coal: 'coal_igcc_ccs'
    energy_power_combined_cycle_ccs_network_gas: 'gas_ccgt_ccs'
    energy_power_combined_cycle_coal: 'coal_igcc'
    energy_power_combined_cycle_network_gas: 'gas_ccgt'
    energy_power_engine_diesel: 'diesel_engine'
    energy_power_nuclear_gen2_uranium_oxide: 'nuclear_ii'
    energy_power_nuclear_gen3_uranium_oxide: 'nuclear_iii'
    energy_power_supercritical_coal: 'coal_conv'
    energy_power_turbine_network_gas: 'gas_turbine'
    energy_power_ultra_supercritical_ccs_coal: 'coal_pwd_ccs'
    energy_power_ultra_supercritical_coal: 'coal_pwd'
    energy_power_ultra_supercritical_crude_oil: 'oil_plant'
    energy_power_ultra_supercritical_network_gas: 'gas_conv'
