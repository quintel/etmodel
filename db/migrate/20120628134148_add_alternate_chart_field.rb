class AddAlternateChartField < ActiveRecord::Migration
  def up
    add_column :slides, :alt_output_element_id, :integer
    Slide.reset_column_information
    Slide.find_each do |s|
      s.update_attribute :alt_output_element_id, s.output_element_id
    end
  end

  def down
    remove_column :slides, :alt_output_element_id
  end
end
