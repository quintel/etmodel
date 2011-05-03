class ChangeCostConstraintName < ActiveRecord::Migration
  def self.up
    c = Constraint.find_by_key('total_energy_cost')
    c.update_attribute(:name, "Cost")
  end

  def self.down
  end
end
