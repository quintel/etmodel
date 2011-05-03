class AddUnitAndFactorToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :unit, :string
    add_column :input_elements, :factor, :float

    InputElement.update_all("factor = 100, unit = '%'")
  end

  def self.down
    remove_column :input_elements, :factor
    remove_column :input_elements, :unit
  end
end
