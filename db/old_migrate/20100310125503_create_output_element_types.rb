class CreateOutputElementTypes < ActiveRecord::Migration
  def self.up
    create_table :output_element_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :output_element_types
  end
end
