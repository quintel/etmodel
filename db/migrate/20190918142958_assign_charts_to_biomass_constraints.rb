class AssignChartsToBiomassConstraints < ActiveRecord::Migration[5.2]
  CONSTRAINTS = {
    biomass_primary_demand: :biomass_demand_by_category,
    biomass_final_demand: :biomass_demand_by_category,
    biomass_import_share: :biomass_sankey
  }.freeze

  def up
    CONSTRAINTS.each do |c_key, oe_key|
      constraint = Constraint.where(key: c_key).first!
      element = OutputElement.where(key: oe_key).first!

      constraint.update!(output_element_id: element.id)
    end
  end

  def down
    CONSTRAINTS.each do |c_key, oe_key|
      Constraint.where(key: c_key).first!.update!(output_element_id: nil)
    end
  end
end
