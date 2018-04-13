class AddElectricityNetworkDemandCharts < ActiveRecord::Migration[5.1]
  COLORS = %w[
    #629DF9 #CE7013 #DC1912 #4A3609 #3BFAEB #B895F6 #F76814 #9DD5FA
    #AF63F1 #F0904C #FBE875 #407A8E #AA2D02 #201A39 #131D1C #D7B00F
    #4E60D1 #08A549 #00A7B4 #DFFBE5 #CE8814 #566D0B #9B9303 #2ACD99
    #EE9F6E #2F2661 #398E4A #D7E91D #0B7E6D #75EEA3 #D0F2B4 #A3BFF6
    #3D6B0D #896F0F #065530 #295888 #94F95C #C6E0E9 #EDB406 #F27D3A
  ]

  CHARTS = [
    {
      key: 'lv_demand_curves',
      series: [
        :lv_buildings_appliances,
        :lv_buildings_cooling,
        :lv_buildings_lighting,
        :lv_buildings_space_heating,
        :lv_ev,
        :lv_households_appliances,
        :lv_households_cooker,
        :lv_households_cooling,
        :lv_households_hot_water,
        :lv_households_lighting,
        :lv_households_space_heating
      ]
    },
    {
      key: 'mv_demand_curves',
      series: [
        :network_lv,
        :mv_industry_metals,
        :mv_other,
        :mv_transport
      ]
    },
    {
      key: 'hv_demand_curves',
      series: [
        :network_mv,
        :hv_buildings_space_heating,
        :hv_agriculture,
        :hv_industry_chemical,
        :hv_industry_metals,
        :hv_industry_other,
        :hv_loss,
        :hv_other
      ]
    }
  ]

  def up
    # Add a new output element type, shared with the old dynamic demand chart.
    type = OutputElementType.create!(name: 'demand_curve')

    OutputElement
      .find_by_key(:dynamic_demand_curve)
      .update_attribute(:output_element_type, type)

    CHARTS.each do |attributes|
      colors = COLORS.cycle

      element = OutputElement.create!(
        output_element_type: type,
        group: 'Merit',
        unit: 'MW',
        key: attributes[:key],
        requires_merit_order: true
      )

      attributes[:series].each do |label|
        OutputElementSerie.create!(
          output_element: element,
          label: label,
          color: colors.next,
          gquery: "#{label}_load_curve"
        )
      end
    end
  end

  def down
    type = OutputElementType.find_by_name!('d3')

    OutputElement
      .find_by_key(:dynamic_demand_curve)
      .update_attribute(:output_element_type, type)

    CHARTS.each do |attributes|
      OutputElement.find_by_key(attributes[:key]).destroy!
    end

    OutputElementType.find_by_name!('demand_curve').destroy!
  end
end
