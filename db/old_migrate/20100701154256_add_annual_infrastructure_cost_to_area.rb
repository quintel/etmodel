class AddAnnualInfrastructureCostToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :annual_infrastructure_cost, :float
  end

  def self.down
    remove_column :areas, :annual_infrastructure_cost
  end
end
