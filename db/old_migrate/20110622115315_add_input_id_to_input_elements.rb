class AddInputIdToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :input_id, :integer
    InputElement.all.each do |input_element|
      input_element.update_attribute :input_id, input_element.id
    end
  end

  def self.down
    remove_column :input_elements, :input_id
  end
end
