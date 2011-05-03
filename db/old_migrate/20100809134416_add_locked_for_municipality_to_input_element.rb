class AddLockedForMunicipalityToInputElement < ActiveRecord::Migration
  def self.up
    unless InputElement.column_names.include?("locked_for_municipalities")
      add_column :input_elements, :locked_for_municipalities, :boolean, :default => false
    end
  end

  def self.down
    remove_column :input_elements, :locked_for_municipalities
  end
end
