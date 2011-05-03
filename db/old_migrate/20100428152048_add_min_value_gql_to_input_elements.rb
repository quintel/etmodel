class AddMinValueGqlToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :min_value_gql, :string
    add_column :input_elements, :max_value_gql, :string
  end

  def self.down
    remove_column :input_elements, :max_value_gql
    remove_column :input_elements, :min_value_gql
  end
end
