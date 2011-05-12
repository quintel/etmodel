class ConvertOutputElementSeriesKeyToGqueries < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :gquery, :string, :null => false
    OutputElementSerie.reset_column_information
    
    OutputElementSerie.find_each do |serie|
      next if serie.output_element.blank?
      clean_label = serie.label.downcase.gsub(/[^a-z0-9_]/, '_')
      gquery_name = "chart_#{clean_label}_#{serie.output_element.key}"
      serie.update_attribute :gquery, gquery_name
    end
  end

  def self.down
    remove_column :output_element_series, :gquery
  end
end
