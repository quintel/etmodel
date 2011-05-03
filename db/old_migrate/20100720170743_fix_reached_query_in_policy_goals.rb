class FixReachedQueryInPolicyGoals < ActiveRecord::Migration
  def self.up
    goal = ::PolicyGoal.find_by_key('co2_emission')
    goal.reached_query = 'LESS_OR_EQUAL(UNIT(Q(co2_emission_total);billions),GOAL(co2_emission))'
    goal.save
    goal = ::PolicyGoal.find_by_key('net_energy_import')
    goal.reached_query = 'LESS_OR_EQUAL(Q(energy_dependence),GOAL(net_energy_import))'
    goal.save
    goal = ::PolicyGoal.find_by_key('net_electricity_import')
    goal.reached_query = 'LESS_OR_EQUAL(Q(electricity_dependence),GOAL(net_electricity_import))'
    goal.save
    goal = ::PolicyGoal.find_by_key('total_energy_cost')
    goal.reached_query = 'LESS_OR_EQUAL(UNIT(Q(cost_total);billions),GOAL(total_energy_cost))'
    goal.save
    goal = ::PolicyGoal.find_by_key('electricity_cost')
    goal.reached_query = 'LESS_OR_EQUAL(PRODUCT(SECS_PER_HOUR,Q(avg_total_cost_for_electricity_production_per_mj)),GOAL(electricity_cost))'
    goal.save
    goal = ::PolicyGoal.find_by_key('renewable_percentage')
    goal.reached_query = 'GREATER_OR_EQUAL(Q(share_of_renewable_energy),GOAL(renewable_percentage))'
    goal.save
    goal = ::PolicyGoal.find_by_key('onshore_land')
    goal.reached_query = 'LESS_OR_EQUAL(V(wind_inland_energy;total_land_use),GOAL(onshore_land))'
    goal.save
    goal = ::PolicyGoal.find_by_key('onshore_coast')
    goal.reached_query = 'LESS_OR_EQUAL(V(wind_coastal_energy;total_land_use),GOAL(onshore_coast))'
    goal.save
    goal = ::PolicyGoal.find_by_key('offshore')
    goal.reached_query = 'LESS_OR_EQUAL(V(wind_offshore_energy;total_land_use),GOAL(offshore))'
    goal.save
    goal = ::PolicyGoal.find_by_key('roofs_for_solar_panels')
    goal.reached_query = 'LESS_OR_EQUAL(V(local_solar_pv_grid_connected_energy_energetic;total_land_use),GOAL(roofs_for_solar_panels))'
    goal.save
    goal = ::PolicyGoal.find_by_key('land_for_solar_panels')
    goal.reached_query = 'LESS_OR_EQUAL(V(solar_pv_central_production_energy_energetic;total_land_use),GOAL(land_for_solar_panels))'
    goal.save
    goal = ::PolicyGoal.find_by_key('land_for_csp')
    goal.reached_query = 'LESS_OR_EQUAL(V(solar_csp_energy;total_land_use),GOAL(land_for_csp))'
    goal.save
  end

  def self.down
    # leave the queries alone, they never worked so the new ones are always better
  end
end
