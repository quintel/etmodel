class AddConstraintForExcessHours < ActiveRecord::Migration
  def change
    output_element = OutputElement.find_by_key('merit_order_excess_events')

    Constraint.create!(
      key:               'total_number_of_excess_events',
      gquery_key:        'dashboard_total_number_of_excess_events',
      group:             'import',
      output_element_id: output_element.id
    )
  end
end
