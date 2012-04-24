class RemoveEtengineTables < ActiveRecord::Migration
  def self.up
    drop_table :blackbox_gqueries          
    drop_table :blackbox_output_series     
    drop_table :blackbox_scenarios         
    drop_table :blackboxes                 
    drop_table :blueprint_layouts          
    drop_table :blueprint_models           
    drop_table :blueprints                 
    drop_table :blueprints_converters      
    drop_table :carrier_datas              
    drop_table :carriers                   
    drop_table :converter_datas            
    drop_table :converter_positions        
    drop_table :converters                 
    drop_table :converters_groups          
    drop_table :datasets                   
    drop_table :gql_test_cases             
    drop_table :graphs                     
    drop_table :link_datas                 
    drop_table :links                      
    drop_table :slot_datas                 
    drop_table :slots                      
    drop_table :time_curve_entries
  end

  def self.down
  end
end

