class AddConstraintForHouseholdRenewables < ActiveRecord::Migration
  def change
    output_element = OutputElement.find_by_key('renewability')

    Constraint.create!(
      key:               'renewable_percentage_households',
      gquery_key:        'dashboard_renewability_households',
      group:             'renewable',
      output_element_id: output_element.id
    )
  end
end
