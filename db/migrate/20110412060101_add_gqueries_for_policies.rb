class AddGqueriesForPolicies < ActiveRecord::Migration
  def self.up
    add_column :constraints, :gquery_id, :integer

    g = Constraint.find(1).create_gquery :key => 'policy_total_primary_energy', 
      :query => "Q(primary_demand_of_final_demand)"
    Constraint.find(1).update_attribute :gquery_id, g.id
    g = Constraint.find(2).create_gquery :key => 'policy_co2_reduction',
      :query => "SUM(-1,DIVIDE(Q(co2_emission_total),AREA(co2_emission_1990_billions)))"
    Constraint.find(2).update_attribute :gquery_id, g.id
    
    g = Constraint.find(3).create_gquery :key => 'policy_net_energy_import',
      :query => "Q(energy_dependence)"
    Constraint.find(3).update_attribute :gquery_id, g.id

    g = Constraint.find(4).create_gquery :key => 'policy_total_energy_cost',
      :query => "UNIT(Q(cost_total);billions)"
    Constraint.find(4).update_attribute :gquery_id, g.id

    g = Constraint.find(5).create_gquery :key => 'policy_not_shown',
      :query => "Q(area_footprint_per_nl)"
    Constraint.find(5).update_attribute :gquery_id, g.id

    g = Constraint.find(6).create_gquery :key => 'policy_renewable_percentage',
      :query => "Q(share_of_renewable_energy)"
    Constraint.find(6).update_attribute :gquery_id, g.id

    g = Constraint.find(7).create_gquery :key => 'policy_targets_met',
      :query => "stored.policy_targets_met"
    Constraint.find(7).update_attribute :gquery_id, g.id

    g = Constraint.find(8).create_gquery :key => 'policy_score',
      :query => "stored.policy_score"
    Constraint.find(8).update_attribute :gquery_id, g.id

  end

  def self.down
    remove_column :constraints, :gquery_id
    Gquery.find_by_key('policy_total_primary_energy').andand.destroy
    Gquery.find_by_key('policy_co2_reduction').andand.destroy
    Gquery.find_by_key('policy_net_energy_import').andand.destroy
    Gquery.find_by_key('policy_total_energy_cost').andand.destroy
    Gquery.find_by_key('policy_not_shown').andand.destroy
    Gquery.find_by_key('policy_renewable_percentage').andand.destroy
    Gquery.find_by_key('policy_targets_met').andand.destroy
    Gquery.find_by_key('policy_score').andand.destroy
  end
end