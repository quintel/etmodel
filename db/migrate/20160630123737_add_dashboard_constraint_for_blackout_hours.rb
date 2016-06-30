class AddDashboardConstraintForBlackoutHours < ActiveRecord::Migration
  def change
    output_element = OutputElement.find_by_key('merit_order_hourly_supply')

    Constraint.create!(
      key: 'blackout_hours',
      gquery_key: 'dashboard_blackout_hours',
      group: 'import',
      output_element_id: output_element.id
    )
  end
end
