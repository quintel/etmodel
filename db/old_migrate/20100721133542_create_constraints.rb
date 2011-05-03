class CreateConstraints < ActiveRecord::Migration
  def self.up
    create_table :constraints do |t|
      t.string :key
      t.string :name
      t.string :extended_title
      t.string :query

      t.timestamps
    end

    Constraint.new(:key => 'total_primary_energy', :name => "Energy use", :extended_title => 'Primary energy use',
                   :query => 'Q(primary_demand_of_final_demand)').save
    Constraint.new(:key => 'co2_reduction', :name => 'CO2 emissions', :extended_title => 'CO2 emissions',
                   :query => 'Q(co2_emission_total)').save
    Constraint.new(:key => 'net_energy_import', :name => 'Dependence', :extended_title => 'Net foreign dependence',
                   :query => 'Q(energy_dependence)').save
    Constraint.new(:key => 'total_energy_cost', :name => 'Cost (bln)', :extended_title => 'Annual energy costs (in billions of Euros)',
                   :query => 'Q(cost_total)').save
    Constraint.new(:key => 'not_shown', :name => 'Bio-footprint', :extended_title => 'Footprint of biomass applications',
                   :query => 'Q(area_footprint_per_nl)').save
    Constraint.new(:key => 'renewable_percentage', :name => 'Renewables', :extended_title => 'Total share of renewable energy',
                   :query => 'Q(share_of_renewable_energy)').save
    Constraint.new(:key => 'targets_met', :name => 'Policies met', :extended_title => 'Policies which are met or not',
                   :query => 'stored.policy_targets_met').save

  end

  def self.down
    drop_table :constraints
  end
end
