class AddHistoricKeyToOutputSeries < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :historic_key, :string
  end

  def self.down
    remove :output_element_series, :historic_key
  end
end
