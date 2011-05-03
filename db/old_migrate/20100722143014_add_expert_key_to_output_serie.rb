class AddExpertKeyToOutputSerie < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :expert_key, :string
  end

  def self.down
    remove :output_element_series, :expert_key
  end
end
