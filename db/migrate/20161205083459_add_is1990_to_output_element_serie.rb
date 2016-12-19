class AddIs1990ToOutputElementSerie < ActiveRecord::Migration
  def change
    add_column :output_element_series, :is_1990, :boolean
  end
end
