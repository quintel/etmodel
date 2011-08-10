class AddInputElementCommandType < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :command_type, :string
    add_index :input_elements, :command_type

    InputElement.reset_column_information
    InputElement.update_all("command_type = 'growth_rate'", "growth = 1")

    remove_column :input_elements, :growth
  end

  def self.down
    add_column :input_elements, :growth, :boolean
    
    InputElement.reset_column_information
    InputElement.update_all("growth = 1", "command_type = 'growth_rate'")

    remove_column :input_elements, :command_type
  end
end
