class ChangeExplanationColumnFromStringToText < ActiveRecord::Migration
  def self.up
    change_column :input_elements, :explanation, :text
  end

  def self.down
    change_column :input_elements, :explanation, :string
  end
end
