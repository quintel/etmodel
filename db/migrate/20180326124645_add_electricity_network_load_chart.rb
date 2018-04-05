class AddElectricityNetworkLoadChart < ActiveRecord::Migration[5.1]
  def up
    chart = OutputElement.create!(
      key: 'electricity_network_load',
      unit: 'MW',
      group: 'Supply',
      output_element_type: OutputElementType.find_by_name('d3'),
      requires_merit_order: true
    )

    chart.output_element_series.create!(
      label: 'network_lv_load_curve',
      gquery: 'network_lv_load_curve',
      color: 'green'
    )

    chart.output_element_series.create!(
      label: 'network_mv_load_curve',
      gquery: 'network_mv_load_curve',
      color: 'blue'
    )

    chart.output_element_series.create!(
      label: 'network_hv_load_curve',
      gquery: 'network_hv_load_curve',
      color: 'red'
    )

    %w[lv mv hv].each do |level|
      chart = OutputElement.create!(
        key: "electricity_#{level}_network_load",
        unit: 'MW',
        group: 'Merit',
        output_element_type: OutputElementType.find_by_name('d3'),
        requires_merit_order: true
      )

      chart.output_element_series.create!(
        label: "network_#{level}_load_curve",
        gquery: "network_#{level}_load_curve",
        color: 'blue'
      )

      chart.output_element_series.create!(
        label: "network_#{level}_supply_curve",
        gquery: "network_#{level}_supply_curve",
        color: 'green'
      )

      chart.output_element_series.create!(
        label: "network_#{level}_demand_curve",
        gquery: "network_#{level}_demand_curve",
        color: 'red'
      )
    end
  end

  def down
    OutputElement.find_by_key('electricity_network_load').destroy!
    OutputElement.find_by_key('electricity_lv_network_load').destroy!
    OutputElement.find_by_key('electricity_mv_network_load').destroy!
    OutputElement.find_by_key('electricity_hv_network_load').destroy!
  end
end
