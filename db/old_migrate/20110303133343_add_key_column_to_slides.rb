class AddKeyColumnToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :key, :string
    add_index :slides, :key
    Slide.reset_column_information
    Slide.all.each do |x|
      key = "#{x.controller_name}_#{x.action_name}_#{x.name}".gsub(/[^a-zA-Z0-9_]/, "_").gsub(/_{2,}/, "_").downcase
      x.update_attribute :key, key
    end
  end

  def self.down
    remove_column :slides, :key
  end
end
