class AddStartValueGqlToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :start_value_gql, :string
  end

  def self.down
    remove_column :input_elements, :start_value_gql
  end
end
