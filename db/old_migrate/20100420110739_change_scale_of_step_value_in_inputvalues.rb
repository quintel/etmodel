class ChangeScaleOfStepValueInInputvalues < ActiveRecord::Migration
  def self.up
    change_column :input_elements, :step_value, :decimal, :precision => 4, :scale => 2
  end

  def self.down
    change_column :input_elements, :step_value, :decimal, :precision => 10, :scale => 0
  end
end
