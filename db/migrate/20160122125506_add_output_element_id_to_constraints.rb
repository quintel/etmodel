class AddOutputElementIdToConstraints < ActiveRecord::Migration
  def change
    add_column :constraints, :output_element_id, :integer
    add_column :constraints, :chart_number, :integer

    chart_numbers = {
      'co2_reduction' => 46,
      'employment' => 118,
      'household_energy_cost' => 113,
      'local_co2_reduction' => 46,
      'loss_of_load' => 111,
      'profitability' => 140,
      'renewable_electricity_percentage' => 112,
      'renewable_percentage' => 49,
      'total_energy_cost' => 48,
      'total_primary_energy' => 45
    }

    chart_numbers.each_pair do |key, chart_number|
      Constraint.find_by_key(key)
        .update_attribute(:chart_number, chart_number)
    end
  end
end
