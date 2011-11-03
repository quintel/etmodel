class AddHouseholdCostsConstraint < ActiveRecord::Migration
  def self.up
    Constraint.create(
      key:            'household_energy_cost',
      name:           'Household cost',
      extended_title: 'Annual energy cost per household',
      gquery_key:     'dashboard_total_costs_per_household',
      group:          'costs'
    )
  end

  def self.down
    Constraint.where(key: 'household_energy_cost').first.destroy
  end
end
