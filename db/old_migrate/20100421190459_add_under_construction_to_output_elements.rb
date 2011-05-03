class AddUnderConstructionToOutputElements < ActiveRecord::Migration
  def self.up
    add_column :output_elements, :under_construction, :boolean, :default => 0
  end

  def self.down
    remove_column :output_elements, :under_construction
  end
end
