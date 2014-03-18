NEAREST_FIFTY = (value) ->
  modulus = value % 50
  if modulus >= 25
    value + (50 - modulus)
  else
    value - modulus

window.forQuery = (query) ->
  key = query.get 'key'
  if found = TRANSFORMS[ key ]
    found
  else
    TRANSFORMS[ key ] = _.identity

TRANSFORMS =
  merit_order_central_gas_chp_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_coal_chp_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_coal_conv_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_coal_igcc_ccs_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_coal_igcc_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_coal_pwd_ccs_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_coal_pwd_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_gas_ccgt_ccs_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_gas_ccgt_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_gas_conv_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_gas_engine_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_gas_turbine_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_must_run_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_nuclear_iii_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_oil_plant_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_solar_pv_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_wind_turbines_full_load_hours_in_merit_order_table: NEAREST_FIFTY
  merit_order_hydro_river_full_load_hours_in_merit_order_table: NEAREST_FIFTY
