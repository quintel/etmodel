class AddLocalCo2DashboardItem < ActiveRecord::Migration
  def change
    Constraint.create!(
      key: 'local_co2_reduction', group: 'co2',
      gquery_key: 'dashboard_reduction_of_local_co2_emissions_versus_1990')
  end
end
