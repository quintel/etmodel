class AddChartsKeyColumn < ActiveRecord::Migration
  def self.up
    add_column :output_elements, :key, :string
    add_index :output_elements, :key
    OutputElement.reset_column_information
    OutputElement.all.each do |x|
      key = "#{x.id}_#{x.name}".gsub(/[^a-zA-Z0-9_]/, "_").gsub(/_{2,}/, "_").downcase
      x.update_attribute :key, key
    end
  end

  def self.down
    remove_column :output_elements, :key
  end
end
