class ChangeInputKeyToText < ActiveRecord::Migration
  def self.up
     change_column :input_elements, :keys, :text
   end

   def self.down
     change_column :input_elements, :keys, :string
   end
end
