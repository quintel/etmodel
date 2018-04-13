class AddElectricityNetworkCapacityTable < ActiveRecord::Migration[5.1]
  def up
    OutputElement.create!(
      key: 'electricity_network_capacity_and_peaks',
      group: 'Supply',
      output_element_type: OutputElementType.find_by_name!('html_table')
    )
  end

  def down
    OutputElement.find_by_key!('electricity_network_capacity_and_peaks').destroy!
  end
end
