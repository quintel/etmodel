class CreateOutputElementSeriesForMeritOrderCharts < ActiveRecord::Migration
  def change
    output_element = OutputElement.find_by_key('merit_order')

    [
      {key: 'central_gas_chp',                        color: '#d9d9d9'},
      {key: 'coal_chp',                               color: '#737373'},
      {key: 'coal_chp_cofiring',                      color: '#83A374'},
      {key: 'coal_conv',                              color: '#000000'},
      {key: 'coal_igcc',                              color: '#525252'},
      {key: 'coal_igcc_ccs',                          color: '#9ebcda'},
      {key: 'coal_pwd',                               color: '#252525'},
      {key: 'coal_pwd_cofiring',                      color: '#4B8056'},
      {key: 'coal_pwd_ccs',                           color: '#8c96c6'},
      {key: 'diesel_engine',                          color: '#854321'},
      {key: 'gas_ccgt',                               color: '#f0f0f0'},
      {key: 'gas_ccgt_ccs',                           color: '#bfd3e6'},
      {key: 'gas_conv',                               color: '#969696'},
      {key: 'gas_engine',                             color: '#F5F5F5'},
      {key: 'gas_turbine',                            color: '#bdbdbd'},
      {key: 'lignite',                                color: '#593B0A'},
      {key: 'lignite_chp',                            color: '#574528'},
      {key: 'lignite_oxy',                            color: '#593B0A'},
      {key: 'must_run',                               color: '#a1d99b'},
      {key: 'nuclear_iii',                            color: '#fd8d3c'},
      {key: 'nuclear_ii',                             color: '#C97E04'},
      {key: 'oil_plant',                              color: '#7f2704'},
      {key: 'buildings_solar_pv_solar_radiation',     color: '#fed976'},
      {key: 'households_solar_pv_solar_radiation',    color: '#eed976'},
      {key: 'energy_power_solar_pv_solar_radiation',  color: '#ded976'},
      {key: 'energy_power_solar_csp_solar_radiation', color: '#ced976'},
      {key: 'geothermal',                             color: '#0ed976'},
      {key: 'coastal_wind_turbines',                  color: '#4292c6'},
      {key: 'offshore_wind_turbines',                 color: '#7292c6'},
      {key: 'onshore_wind_turbines',                  color: '#9292c6'},
      {key: 'hydro_mountain',                         color: '#0066ff'},
      {key: 'hydro_river',                            color: '#0066ff'}
    ].each do |obj|
      OutputElementSerie.create!(
        output_element_id: output_element.id,
        label:             obj[:key],
        color:             obj[:color],
        gquery:            "#{ obj[:key] }_merit_order",
        is_target_line:    false
      )
    end
  end
end
